BIN_FOLDER = "bin"
GEMSPEC = ".gemspec"

def _package_name(spec)
  package_name = spec.name
  package_version = spec.version
  "#{package_name}-#{package_version}"
end

task :build do
  # Create the bin folder if it does not yet exist
  FileUtils.mkdir_p(BIN_FOLDER)

  # Clear out all files in the bin folder
  FileUtils.rm_r("#{BIN_FOLDER}/*", force: true)

  # Build the gem
  system("gem build #{GEMSPEC}")
  spec = Gem::Specification::load(GEMSPEC)

  # Move the artifact into the bin folder
  package_name = _package_name(spec)
  File.rename("#{package_name}.gem", "#{BIN_FOLDER}/#{package_name}.gem")
end

task :install => :build do
  # Uninstall and install the gem
  spec = Gem::Specification::load(GEMSPEC)
  package_name = _package_name(spec)
  system("gem uninstall #{package_name}")
  system("gem install #{BIN_FOLDER}/#{package_name}.gem")
end

task :publish => :build do
  # Build and push the gem
  spec = Gem::Specification::load(GEMSPEC)
  package_name = _package_name(spec)
  # system("gem push #{BIN_FOLDER}/#{package_name}.gem")
end