# frozen_string_literal: true

require "spec_helper"

RSpec.describe RuboCop::Cop::SpecStructure::SpecFileExists do
  subject(:cop) { described_class.new(config) }

  let(:config) do
    RuboCop::Config.new(
      "SpecStructure/SpecFileExists" => {
        "Enabled" => true,
        "SourceDirectories" => ["lib"],
        "SpecDirectory" => "spec"
      }
    )
  end

  describe "#on_new_investigation" do
    context "when file is not in source directories" do
      it "does not register an offense for bin files" do
        expect_no_offenses(<<~RUBY, "bin/console")
          puts 'hello'
        RUBY
      end

      it "does not register an offense for config files" do
        expect_no_offenses(<<~RUBY, "/project/config/settings.rb")
          CONFIG = {}
        RUBY
      end
    end

    context "when file is not a ruby file" do
      it "does not register an offense" do
        expect_no_offenses(<<~RUBY, "lib/foo.txt")
          some text
        RUBY
      end
    end

    context "when file is in spec directory" do
      it "does not register an offense for spec files" do
        expect_no_offenses(<<~RUBY, "/project/spec/lib/foo_spec.rb")
          RSpec.describe Foo do; end
        RUBY
      end
    end

    context "when file is a source file" do
      before do
        allow(RuboCop::ConfigFinder).to receive(:project_root).and_return("/project")
      end

      context "when corresponding spec file exists" do
        before do
          allow(File).to receive(:exist?)
            .with("/project/spec/lib/foo/bar_spec.rb")
            .and_return(true)
        end

        it "does not register an offense" do
          expect_no_offenses(<<~RUBY, "/project/lib/foo/bar.rb")
            class Bar; end
          RUBY
        end
      end

      context "when corresponding spec file does not exist" do
        before do
          allow(File).to receive(:exist?)
            .with("/project/spec/lib/foo/bar_spec.rb")
            .and_return(false)
        end

        it "registers an offense" do
          expect_offense(<<~RUBY, "/project/lib/foo/bar.rb")
            class Bar; end
            ^{} Missing spec file: `spec/lib/foo/bar_spec.rb`.
          RUBY
        end
      end

      context "when file is in nested directory" do
        before do
          allow(File).to receive(:exist?)
            .with("/project/spec/lib/deeply/nested/module_spec.rb")
            .and_return(false)
        end

        it "registers an offense with correct path" do
          expect_offense(<<~RUBY, "/project/lib/deeply/nested/module.rb")
            module Nested; end
            ^{} Missing spec file: `spec/lib/deeply/nested/module_spec.rb`.
          RUBY
        end
      end
    end

    context "with custom source directories" do
      let(:config) do
        RuboCop::Config.new(
          "SpecStructure/SpecFileExists" => {
            "Enabled" => true,
            "SourceDirectories" => ["lib", "app"],
            "SpecDirectory" => "spec"
          }
        )
      end

      before do
        allow(RuboCop::ConfigFinder).to receive(:project_root).and_return("/project")
        allow(File).to receive(:exist?)
          .with("/project/spec/app/models/user_spec.rb")
          .and_return(false)
      end

      it "checks app directory as well" do
        expect_offense(<<~RUBY, "/project/app/models/user.rb")
          class User; end
          ^{} Missing spec file: `spec/app/models/user_spec.rb`.
        RUBY
      end
    end
  end
end
