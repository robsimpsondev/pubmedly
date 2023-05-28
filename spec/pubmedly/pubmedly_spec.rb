# frozen_string_literal: true

module Pubmedly
  RSpec.describe Pubmedly do
    it "has a version number" do
      expect(VERSION).not_to be_nil
    end

    it "defines field tags" do
      expect(FIELD_TAGS).to be_a(Hash)
      expect(FIELD_TAGS["Author"]).to eq ["au"]
    end
  end
end
