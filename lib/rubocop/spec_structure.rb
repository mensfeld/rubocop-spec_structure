# frozen_string_literal: true

module RuboCop
  # RuboCop SpecStructure plugin namespace
  # Provides cops to enforce spec file structure conventions
  module SpecStructure
    # Project root path
    PROJECT_ROOT = Pathname.new(__dir__).parent.parent.expand_path.freeze

    # Default configuration file path
    CONFIG_DEFAULT = PROJECT_ROOT.join("config", "default.yml").freeze
  end
end
