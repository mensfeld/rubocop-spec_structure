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
      it "does not register an offense" do
        expect_no_offenses(<<~RUBY, "bin/console")
          puts 'hello'
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
  end
end
