# frozen_string_literal: true

module RuboCop
  module Cop
    module SpecStructure
      # Checks that source files have corresponding spec files.
      #
      # @example
      #   # With default configuration, for a file lib/foo/bar.rb,
      #   # expects spec/lib/foo/bar_spec.rb to exist.
      #
      class SpecFileExists < Base
        MSG = "Missing spec file: `%<expected_path>s`."

        def on_new_investigation
          return unless source_file?
          return if spec_file_exists?

          add_global_offense(format(MSG, expected_path: expected_spec_path))
        end

        private

        def source_file?
          return false unless processed_source.file_path&.end_with?(".rb")

          source_directories.any? do |dir|
            processed_source.file_path.include?("/#{dir}/")
          end
        end

        def spec_file_exists?
          File.exist?(absolute_spec_path)
        end

        def expected_spec_path
          relative_path = processed_source.file_path
            .sub(%r{^.*/(?:#{source_directories.join("|")})/}, "")
            .sub(/\.rb$/, "_spec.rb")

          source_dir = source_directories.find do |dir|
            processed_source.file_path.include?("/#{dir}/")
          end

          File.join(spec_directory, source_dir.to_s, relative_path)
        end

        def absolute_spec_path
          File.join(project_root, expected_spec_path)
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
