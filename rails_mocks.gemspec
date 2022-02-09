# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "rails_mocks/version"

Gem::Specification.new do |spec|
  spec.name          = "rails_mocks"
  spec.version       = RailsMocks::VERSION
  spec.authors       = [ "Anton Kachan" ]
  spec.email         = [ "anton.kachan@freshly.com" ]

  spec.summary       = "Makes stubbing in your Rails application from an external resource easier."
  spec.description   = "Provides rspec-mocks syntax from an external source like cypress"
  spec.homepage      = "https://github.com/anton-kachan/rails_mocks"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/anton-kachan/rails_mocks/blob/master/CHANGELOG.md"

  spec.files = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  spec.require_paths = "lib"

  spec.add_dependency "rails", "~> 6.1.0"
  spec.add_dependency "rspec-mocks", "~> 3.11"
  spec.add_dependency "rspec-core", "~> 3.11"
  spec.add_dependency "proto_pharm", "~> 0.7.0"

  spec.add_development_dependency "pry-byebug", "~> 3.7"
end