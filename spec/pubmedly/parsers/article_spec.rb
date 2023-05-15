# frozen_string_literal: true

require "nokogiri"

FIXTURE_DIR = "#{__dir__}/../../fixtures/parsers/"

module Pubmedly
  module Parsers
    RSpec.describe Article do
      let(:article) { Article.new(
        Nokogiri::XML(File.read("#{FIXTURE_DIR}/pubmed_article.xml"))) }
      let(:random_xml) { Article.new(
        Nokogiri::XML("<Rob><Was>Hello</Was><Ere>World</Ere><></Rob>")) }

      describe "#title" do
        it "returns the title of the article" do
          expect(article.title).to eq("Chemical Constituents, Antioxidant Potential, and Antimicrobial Efficacy of Pimpinella anisum Extracts against Multidrug-Resistant Bacteria.")
        end

        it "returns empty string if no title is found" do
          expect(random_xml.title).to eq ""
        end
      end

      describe "#publication_date" do
        it "returns the publication date of the article" do
          expect(article.publication_date).to eq(Date.parse("2023-04-14"))
        end

        it "returns empty string if no publication date is found" do
          expect(random_xml.publication_date).to eq ""
        end
      end

      describe "#abstract" do
        it "returns the abstract of the article" do
          expect(article.abstract).to include "Aniseeds (Pimpinella anisum) have gained increasing attention for their nutritional and health benefits. Aniseed extracts "
        end

        it "returns empty string if no abstract is found" do
          expect(random_xml.abstract).to eq ""
        end
      end
    end
  end
end
