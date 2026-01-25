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
      it "does not register an offense" do
        expect_no_offenses(<<~RUBY, "lib/foo.rb")
          class Foo; end
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
  end
end
