# frozen_string_literal: true

module RuboCop
  module Cop
    module SpecStructure
      # Checks that spec files have corresponding source files.
      #
      # @example
      #   # With default configuration, for a file spec/lib/foo/bar_spec.rb,
      #   # expects lib/foo/bar.rb to exist.
      #
      class SourceFileExists < Base
        MSG = "Orphan spec file, missing source: `%<expected_path>s`."

        def on_new_investigation
          return unless spec_file?
          return if source_file_exists?

          add_global_offense(format(MSG, expected_path: expected_source_path))
        end

        private

        def spec_file?
          file_path = processed_source.file_path
          return false unless file_path&.end_with?("_spec.rb")
          return false unless file_path.include?("/#{spec_directory}/")

          source_directories.any? do |dir|
            file_path.include?("/#{spec_directory}/#{dir}/")
          end
        end

        def source_file_exists?
          File.exist?(absolute_source_path)
        end

        def expected_source_path
          processed_source.file_path
            .sub(%r{^.*/#{spec_directory}/}, "")
            .sub(/_spec\.rb$/, ".rb")
        end

        def absolute_source_path
          File.join(project_root, expected_source_path)
        end

        def project_root
          RuboCop::ConfigFinder.project_root
        end

        def source_directories
          cop_config.fetch("SourceDirectories", ["lib", "app"])
        end

        def spec_directory
          cop_config.fetch("SpecDirectory", "spec")
        end
      end
    end
  end
end
