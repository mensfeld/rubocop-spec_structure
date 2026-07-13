# frozen_string_literal: true

require "warning"

$VERBOSE = true

if Warning.respond_to?(:categories)
  (Warning.categories - %i[experimental]).each do |cat|
    Warning[cat] = true
  end
end

Warning.process do |warning|
  next unless warning.include?(Dir.pwd)
  next if warning.include?("_spec")
  next if warning.include?("vendor/")
  next if warning.include?("bundle/")
  next if warning.include?(".bundle/")
  raise "Warning in your code: #{warning}"
end

require "simplecov"

SimpleCov.start do
  skip "/spec/"
  enable_coverage :branch
end

require "rubocop"
require "rubocop/rspec/support"
require "rubocop-spec_structure"

RSpec.configure do |config|
  config.include RuboCop::RSpec::ExpectOffense

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.warnings = true

  config.order = :random
  Kernel.srand config.seed
end
