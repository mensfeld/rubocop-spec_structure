# frozen_string_literal: true

require "spec_helper"

RSpec.describe RuboCop::SpecStructure do
  describe "VERSION" do
    subject(:version) { described_class::VERSION }

    it "has a version number" do
      expect(version).not_to be_nil
    end

    it "follows semantic versioning" do
      expect(version).to match(/\A\d+\.\d+\.\d+\z/)
    end
  end
end
