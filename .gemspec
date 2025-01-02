require_relative "lib/sub-resource-integrity-hook/version"

Gem::Specification.new do |s|
  s.name = 'jekyll-sub-resource-integrity-hook'
  s.version = Jekyll::SubResourceIntegrityHook::VERSION
  s.date = '2025-01-02'
  s.summary = 'Introduces the filter `file_integrity` to compute the subresource integrity (SRI) hash of a file.'
  s.description = ''
  s.authors = ['Willem \'Jip\' Wijnia']
  s.files = Dir["lib/**/*"]
  s.homepage = ''
  s.license = 'MIT'

  s.required_ruby_version = ">= 3.0.0"

  s.add_dependency 'jekyll', '> 3.3', '< 5.0'
  s.add_dependency 'nokogiri', '~> 1.18.1'
end
