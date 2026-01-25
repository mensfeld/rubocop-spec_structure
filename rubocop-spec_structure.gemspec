# frozen_string_literal: true

require_relative "lib/rubocop/spec_structure/version"

Gem::Specification.new do |spec|
  spec.name = "rubocop-spec_structure"
  spec.version = RuboCop::SpecStructure::VERSION
  spec.authors = ["Maciej Mensfeld"]
  spec.email = ["maciej@mensfeld.pl"]

  spec.summary = "RuboCop plugin to enforce spec file structure conventions"
  spec.description = "Checks that source files have corresponding spec files and vice versa"
  spec.homepage = "https://github.com/mensfeld/rubocop-spec_structure"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.files = Dir["lib/**/*", "config/**/*", "LICENSE.txt", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "rubocop", ">= 1.0"

  spec.metadata = {
    "rubygems_mfa_required" => "true",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "bug_tracker_uri" => "#{spec.homepage}/issues"
  }
end
