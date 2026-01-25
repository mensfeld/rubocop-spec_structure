# frozen_string_literal: true

require "spec_helper"

RSpec.describe RuboCop::Cop::SpecStructure::SourceFileExists do
  subject(:cop) { described_class.new(config) }

  let(:config) do
    RuboCop::Config.new(
      "SpecStructure/SourceFileExists" => {
        "Enabled" => true,
        "SourceDirectories" => ["lib"],
        "SpecDirectory" => "spec"
      }
    )
  end

  describe "#on_new_investigation" do
    context "when file is not a spec file" do
      it "does not register an offense for source files" do
        expect_no_offenses(<<~RUBY, "lib/foo.rb")
          class Foo; end
        RUBY
      end

      it "does not register an offense for non-spec ruby files" do
        expect_no_offenses(<<~RUBY, "/project/spec/support/helpers.rb")
          module Helpers; end
        RUBY
      end
    end

    context "when file is not in spec directory" do
      it "does not register an offense" do
        expect_no_offenses(<<~RUBY, "test/foo_test.rb")
          class FooTest; end
        RUBY
      end
    end

    context "when spec file is not in a source directory subfolder" do
      it "does not register an offense for spec/support files" do
        expect_no_offenses(<<~RUBY, "/project/spec/support/shared_examples_spec.rb")
          RSpec.describe 'shared' do; end
        RUBY
      end

      it "does not register an offense for top-level spec files" do
        expect_no_offenses(<<~RUBY, "/project/spec/integration_spec.rb")
          RSpec.describe 'integration' do; end
        RUBY
      end
    end

    context "when file is a spec file in source directory subfolder" do
      before do
        allow(RuboCop::ConfigFinder).to receive(:project_root).and_return("/project")
      end

      context "when corresponding source file exists" do
        before do
          allow(File).to receive(:exist?)
            .with("/project/lib/foo/bar.rb")
            .and_return(true)
        end

        it "does not register an offense" do
          expect_no_offenses(<<~RUBY, "/project/spec/lib/foo/bar_spec.rb")
            RSpec.describe Foo::Bar do; end
          RUBY
        end
      end

      context "when corresponding source file does not exist" do
        before do
          allow(File).to receive(:exist?)
            .with("/project/lib/foo/bar.rb")
            .and_return(false)
        end

        it "registers an offense" do
          expect_offense(<<~RUBY, "/project/spec/lib/foo/bar_spec.rb")
            RSpec.describe Foo::Bar do; end
            ^{} Orphan spec file, missing source: `lib/foo/bar.rb`.
          RUBY
        end
      end

      context "when spec is in nested directory" do
        before do
          allow(File).to receive(:exist?)
            .with("/project/lib/deeply/nested/module.rb")
            .and_return(false)
        end

        it "registers an offense with correct path" do
          expect_offense(<<~RUBY, "/project/spec/lib/deeply/nested/module_spec.rb")
            RSpec.describe Deeply::Nested::Module do; end
            ^{} Orphan spec file, missing source: `lib/deeply/nested/module.rb`.
          RUBY
        end
      end
    end

    context "with custom source directories" do
      let(:config) do
        RuboCop::Config.new(
          "SpecStructure/SourceFileExists" => {
            "Enabled" => true,
            "SourceDirectories" => ["lib", "app"],
            "SpecDirectory" => "spec"
          }
        )
      end

      before do
        allow(RuboCop::ConfigFinder).to receive(:project_root).and_return("/project")
        allow(File).to receive(:exist?)
          .with("/project/app/models/user.rb")
          .and_return(false)
      end

      it "checks app directory specs as well" do
        expect_offense(<<~RUBY, "/project/spec/app/models/user_spec.rb")
          RSpec.describe User do; end
          ^{} Orphan spec file, missing source: `app/models/user.rb`.
        RUBY
      end
    end
  end
end
