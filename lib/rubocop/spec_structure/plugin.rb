# frozen_string_literal: true

require "lint_roller"

module RuboCop
  module SpecStructure
    # Plugin class for RuboCop's plugin API
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
          name: "rubocop-spec_structure",
          version: VERSION,
          homepage: "https://github.com/mensfeld/rubocop-spec_structure",
          description: "Checks that source files have corresponding spec files and vice versa"
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

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
