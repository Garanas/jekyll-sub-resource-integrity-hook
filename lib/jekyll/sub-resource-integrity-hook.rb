require 'digest'
require 'base64'
require 'nokogiri'

module Jekyll
  class SubResourceIntegrityHook

    # Translates the URL of a file to a relative path of a file by removing the base url.
    # @param site [Jekyll::Site] The site object
    # @param url [String] The URL to the asset
    # @return [String] The URL to the asset without the baseurl
    def self._compute_path_to_asset(site, url)
      # Try to retrieve the base URL
      baseurl = site.config['baseurl'] || ''

      # Remove the base URL from the path
      url.sub(%r{^#{baseurl}}, '')
    end

    # Compute the sub resource integrity (SRI) hash of a file.
    # @param absolute_path_source [String] Full path to the source file
    # @return [String] As an example: sha256-o8T9MgIvQTJq9KQ1NjwbW+j7FpxmV889HPJpieH8XJE=
    def self._compute_integrity_sha256 (absolute_path_source)
      content = File.binread(absolute_path_source)
      digest = Digest::SHA256.digest(content)
      "sha256-#{Base64.strict_encode64(digest)}"
    end

    # Updates the HTML file by including sub resource integrity (SRI) attributes. The hashes are computed on the fly.
    # @param site [Jekyll::Site] Absolute path to the destination folder
    # @param relative_path_source [String] Relative path of the source file
    def self._process_html (site, relative_path_source)

      # Read and parse the file
      absolute_path_source = File.join(site.dest, _compute_path_to_asset(site, relative_path_source))
      content = File.read(absolute_path_source)
      doc = Nokogiri::HTML(content)

      updated = false
      doc.css('script[src], link[rel="stylesheet"]').each do |tag|
        path = tag['src'] || tag['href']
        next unless path

        # Compute absolute path to asset
        absolute_path_asset = File.join(site.dest, _compute_path_to_asset(site, path))
        next unless File.exist?(absolute_path_asset)

        # Add attributes
        integrity = _compute_integrity_sha256(absolute_path_asset)
        tag['integrity'] = integrity
        tag['crossorigin'] ||= 'anonymous'
        updated = true

        Jekyll.logger.info "Generated subresource integrity hash for: #{absolute_path_source}"
      end

      # Write updated HTML if changes were made
      if updated
        File.write(absolute_path_source, doc.to_html)
      end
    end

    Jekyll::Hooks.register :site, :post_write do |site|
      Jekyll.logger.info "Generating subresource integrity (SRI) hashes..."

      site.each_site_file do |file|
        # Process only HTML files
        next unless file.extname == '.html'

        _process_html(site, file.path)
      end
    end
  end
end