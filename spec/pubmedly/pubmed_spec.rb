# frozen_string_literal: true

require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes/"
  config.hook_into :webmock
  config.filter_sensitive_data("<NCBI_API_KEY>") { ENV.fetch("NCBI_API_KEY", nil) }
end

module Pubmedly
  RSpec.describe Pubmed do
    let(:pubmed) { described_class.new(ENV.fetch("NCBI_API_KEY", nil)) }

    describe "#search" do
      it "returns an array of IDs" do
        VCR.use_cassette("pubmed/search/cancer") do
          expect(pubmed.search("cancer")).to be_an(Array)
          expect(pubmed.search("cancer").first).to be_a(Integer)
        end
      end
    end

    describe "#fetch" do
      it "returns an array of Articles given an ID" do
        VCR.use_cassette("pubmed/fetch/37194105") do
          expect(pubmed.fetch(37194105)).to be_an(Array)
          expect(pubmed.fetch(37194105).first).to be_a(Parsers::Article)
        end
      end

      it "returns an array of Articles given an array of IDs" do
        VCR.use_cassette("pubmed/fetch/37194105_37194085") do
          result = pubmed.fetch([37194105, 37194085])
          expect(result).to be_an(Array)
          expect(result.first).to be_a(Parsers::Article)
          expect(result.first.pmid).to eq 37194105
          expect(result.second.pmid).to eq 37194085
        end
      end

      it "returns an array of Articles given multiple IDs" do
        VCR.use_cassette("pubmed/fetch/37194105_37194085") do
          result = pubmed.fetch(37194105, 37194085)
          expect(result).to be_an(Array)
          expect(result.first).to be_a(Parsers::Article)
          expect(result.first.pmid).to eq 37194105
          expect(result.second.pmid).to eq 37194085
        end
      end
    end

    describe "#articles" do
      it "returns an array of Articles" do
        VCR.use_cassette("pubmed/articles/cancer") do
          result = pubmed.articles("cancer")
          expect(result).to be_an(Array)
          expect(result.first).to be_a(Parsers::Article)
        end
      end

      it "returns an empty array when no articles are found" do
        VCR.use_cassette("pubmed/articles/gyroscopapyrus") do
          result = pubmed.articles("gyroscopapyrus")
          expect(result).to eq []
        end
      end
    end
  end
end
