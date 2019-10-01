lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "custom_tracker/version"

Gem::Specification.new do |spec|
  spec.name          = "custom_tracker"
  spec.version       = CustomTracker::VERSION
  spec.authors       = ["Fizvlad"]
  spec.email         = ["fizvlad@mail.ru"]

  spec.summary       = "A small gem to track custom events and export saved data"
  spec.homepage      = "https://github.com/fizvlad/custom-tracker-rb"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fizvlad/custom-tracker-rb"
  spec.metadata["changelog_uri"] = "https://github.com/fizvlad/custom-tracker-rb/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|examples)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "csv", "~> 3.1"
  spec.add_runtime_dependency "date", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
