# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bonita/version"

Gem::Specification.new do |spec|
  spec.name = "bonita"
  spec.version = Bonita::VERSION
  spec.authors = ["Pierre Deville"]
  spec.email = ["pierre.deville@effilab.com"]

  spec.summary = "Unofficial REST API client for Bonita BPM"
  spec.description = "Unofficial REST API client for Bonita BPM"
  spec.homepage = "http://example.com"
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday-cookie_jar", "~> 0.0.6"
  spec.add_dependency "kartograph", "~> 0.2.4"
  spec.add_dependency "resource_kit", "~> 0.1.6"

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
