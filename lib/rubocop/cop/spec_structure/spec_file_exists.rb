# frozen_string_literal: true

module RuboCop
  module Cop
    module SpecStructure
      # Checks that source files have corresponding spec files.
      #
      # @example
      #   # With default configuration, for a file lib/foo/bar.rb,
      #   # expects spec/lib/foo/bar_spec.rb to exist.
      class SpecFileExists < Base
        # Message displayed when spec file is missing
        MSG = "Missing spec file: `%<expected_path>s`."

        # Called when a new file investigation begins
        # Checks if the current file is a source file and if its corresponding spec exists
        def on_new_investigation
          return unless source_file?
          return if spec_file_exists?

          add_global_offense(format(MSG, expected_path: expected_spec_path))
        end

        private

        # Checks if the current file is a source file (not a spec/test file)
        # @return [Boolean] true if file is in source directories and not in spec directory
        def source_file?
          file_path = processed_source.file_path
          return false unless file_path&.end_with?(".rb")
          return false if file_path.include?("/#{spec_directory}/")

          source_directories.any? do |dir|
            file_path.include?("/#{dir}/")
          end
        end

        # Checks if the corresponding spec file exists
        # @return [Boolean] true if spec file exists
        def spec_file_exists?
          File.exist?(absolute_spec_path)
        end

        # Computes the expected spec file path relative to project root
        # @return [String] expected spec file path
        def expected_spec_path
          relative_path = processed_source.file_path
            .sub(%r{^.*/(?:#{source_directories.join("|")})/}, "")
            .sub(/\.rb$/, "_spec.rb")

          source_dir = source_directories.find do |dir|
            processed_source.file_path.include?("/#{dir}/")
          end

          File.join(spec_directory, source_dir.to_s, relative_path)
        end

        # Computes the absolute path to the expected spec file
        # @return [String] absolute path to spec file
        def absolute_spec_path
          File.join(project_root, expected_spec_path)
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
