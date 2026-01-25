# frozen_string_literal: true

require "lint_roller"

module RuboCop
  module SpecStructure
    # Plugin class for RuboCop's plugin API using LintRoller
    class Plugin < LintRoller::Plugin
      # Returns plugin metadata
      # @return [LintRoller::About] plugin information
      def about
        LintRoller::About.new(
          name: "rubocop-spec_structure",
          version: VERSION,
          homepage: "https://github.com/mensfeld/rubocop-spec_structure",
          description: "Checks that source files have corresponding spec files and vice versa"
        )
      end

      # Checks if the plugin is supported in the given context
      # @param context [LintRoller::Context] context object
      # @return [Boolean] true if the context engine is rubocop
      def supported?(context)
        context.engine == :rubocop
      end

      # Returns the rules configuration
      # @param _context [LintRoller::Context] context object (unused)
      # @return [LintRoller::Rules] rules configuration pointing to default.yml
      def rules(_context)
        LintRoller::Rules.new(
          type: :path,
          config_format: :rubocop,
          value: CONFIG_DEFAULT.to_s
        )
      end
    end
  end
end
