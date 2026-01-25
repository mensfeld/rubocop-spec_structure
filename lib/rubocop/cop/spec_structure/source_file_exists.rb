# frozen_string_literal: true

module RuboCop
  module Cop
    module SpecStructure
      # Checks that spec files have corresponding source files.
      #
      # @example
      #   # With default configuration, for a file spec/lib/foo/bar_spec.rb,
      #   # expects lib/foo/bar.rb to exist.
      class SourceFileExists < Base
        # Message displayed when source file is missing
        MSG = "Orphan spec file, missing source: `%<expected_path>s`."

        # Called when a new file investigation begins
        # Checks if the current file is a spec file and if its corresponding source exists
        def on_new_investigation
          return unless spec_file?
          return if source_file_exists?

          add_global_offense(format(MSG, expected_path: expected_source_path))
        end

        private

        # Checks if the current file is a spec file in a source directory subfolder
        # @return [Boolean] true if file is a spec file for a source directory
        def spec_file?
          file_path = processed_source.file_path
          return false unless file_path&.end_with?("_spec.rb")
          return false unless file_path.include?("/#{spec_directory}/")

          source_directories.any? do |dir|
            file_path.include?("/#{spec_directory}/#{dir}/")
          end
        end

        # Checks if the corresponding source file exists
        # @return [Boolean] true if source file exists
        def source_file_exists?
          File.exist?(absolute_source_path)
        end

        # Computes the expected source file path relative to project root
        # @return [String] expected source file path
        def expected_source_path
          processed_source.file_path
            .sub(%r{^.*/#{spec_directory}/}, "")
            .sub(/_spec\.rb$/, ".rb")
        end

        # Computes the absolute path to the expected source file
        # @return [String] absolute path to source file
        def absolute_source_path
          File.join(project_root, expected_source_path)
        end

        # Returns the project root directory
        # @return [String] project root path
        def project_root
          RuboCop::ConfigFinder.project_root
        end

        # Returns configured source directories
        # @return [Array<String>] list of source directories
        def source_directories
          cop_config.fetch("SourceDirectories", ["lib", "app"])
        end

        # Returns configured spec directory
        # @return [String] spec directory name
        def spec_directory
          cop_config.fetch("SpecDirectory", "spec")
        end
      end
    end
  end
end
