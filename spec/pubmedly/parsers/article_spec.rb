# frozen_string_literal: true

require "nokogiri"

FIXTURE_DIR = "#{__dir__}/../../fixtures/parsers/".freeze

module Pubmedly
  module Parsers
    RSpec.describe Article do
      let(:article) { described_class.new(Nokogiri::XML(File.read("#{FIXTURE_DIR}/pubmed_article.xml"))) }
      let(:random_xml) { described_class.new(Nokogiri::XML("<Rob><Was>Hello</Was><Ere>World</Ere><></Rob>")) }

      describe "#title" do
        it "returns the title of the article" do
          expect(article.title).to eq("Chemical Constituents, Antioxidant Potential, and Antimicrobial Efficacy of " \
                                      "Pimpinella anisum Extracts against Multidrug-Resistant Bacteria.")
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

        context "when only the year is given" do
          let(:article) do
            described_class.new(Nokogiri::XML(File.read("#{FIXTURE_DIR}/pubmed_article_pubdate_year_only.xml")))
          end

          it "returns a Date on 1st January that year" do
            expect(article.publication_date).to eq(Date.strptime("2023", "%Y"))
          end
        end
      end

      describe "#abstract" do
        it "returns the abstract of the article" do
          expect(article.abstract).to include "Aniseeds (Pimpinella anisum) have gained increasing attention for "
        end

        it "returns empty string if no abstract is found" do
          expect(random_xml.abstract).to eq ""
        end
      end

      describe "#authors" do
        it "returns an array of author names" do
          expect(article.authors).to eq ["AlBalawi, Aisha Nawaf", "Elmetwalli, Alaa", "Baraka, Dina M",
                                         "Alnagar, Hadeer A", "Alamri, Eman Saad", "Hassan, Mervat G"]
        end

        it "returns empty array if no authors are found" do
          expect(random_xml.authors).to eq []
        end
      end

      describe "#pmid" do
        it "returns the PMID of the article" do
          expect(article.pmid).to eq 37110449
        end

        it "returns nil if no PMID is found" do
          expect(random_xml.pmid).to be_nil
        end
      end

      describe "pmcid" do
        it "returns the pmcid of the article" do
          expect(article.pmcid).to eq "PMC10144661"
        end

        it "returns empty string if no doi is found" do
          expect(random_xml.pmcid).to eq ""
        end
      end

      describe "doi" do
        it "returns the doi" do
          expect(article.doi).to eq "10.3390/microorganisms11041024"
        end

        it "returns empty string if no doi is found" do
          expect(random_xml.doi).to eq ""
        end
      end
    end
  end
end
