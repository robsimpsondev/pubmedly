# frozen_string_literal: true

require "vcr"
require "net/http"

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data("<NCBI_API_KEY>") { ENV["NCBI_API_KEY"] }
end

module Pubmedly
  RSpec.describe Client do
    let(:client) { Client.new(ENV["NCBI_API_KEY"]) }


    describe "#search" do
      # https://www.ncbi.nlm.nih.gov/books/NBK25499/#chapter4.ESearch

      describe "term" do
        # https://pubmed.ncbi.nlm.nih.gov/help/#how-do-i-search-pubmed

        it "takes a single term" do
          VCR.use_cassette("search/covid") do
            response = client.search("covid")
            expect(response).to be_a Net::HTTPOK
          end
        end

        it "takes multiple terms" do
          VCR.use_cassette("search/covid neuropathy") do
            response = client.search("covid neuropathy")
            expect(response).to be_a Net::HTTPOK
            expect(response.body).to include "<From>covid</From>"
            expect(response.body).to include "<From>neuropathy</From>"
          end
        end

        it "takes a phrase" do
          VCR.use_cassette("search/varicella zoster") do
            response = client.search("\"varicella zoster\"")
            expect(response).to be_a Net::HTTPOK
            expect(response.body).to include "<QueryTranslation>\"varicella zoster\"[All Fields]</QueryTranslation>"
          end
        end

        describe "field tags" do
          # https://pubmed.ncbi.nlm.nih.gov/help/#using-search-field-tags
          
          it "use [au] for author" do
            # https://pubmed.ncbi.nlm.nih.gov/help/#author-search
            VCR.use_cassette("search/simpson[au]") do
              response = client.search("simpson[au]")
              expect(response).to be_a Net::HTTPOK
              expect(response.body).to include "<QueryTranslation>simpson[Author]"
            end
          end

          it "use [pdat] for Publication Date" do
            # https://pubmed.ncbi.nlm.nih.gov/help/#dp
            VCR.use_cassette("search/long covid pdat") do
              response = client.search("long covid 2023/04/23:2023/04/30[pdat]")
              expect(response).to be_a Net::HTTPOK
              expect(response.body).to include "2023/04/23:2023/04/30[Date - Publication]"
            end
          end

          it "use [crdt] for Pubmed Creation Date (more comprehensive than Publication Date)" do
            # https://pubmed.ncbi.nlm.nih.gov/help/#crdt
            VCR.use_cassette("search/long covid crdt") do
              response = client.search("long covid 2023/04/23:2023/04/30[crdt]")
              expect(response).to be_a Net::HTTPOK
              expect(response.body).to include "2023/04/23:2023/04/30[Date - Create]"
            end
          end

          it "use [pdat] with relative dates" do
            # https://pubmed.ncbi.nlm.nih.gov/help/#dp
            VCR.use_cassette("search/long covid last 7 days pdat") do
              response = client.search("long covid \"last 7 days\" [pdat]")
              expect(response).to be_a Net::HTTPOK
              expect(response.body).to include '2023/04/29'
            end
          end

          it "use [crdt] with relative dates" do
            # https://pubmed.ncbi.nlm.nih.gov/help/#dp
            VCR.use_cassette("search/long covid last 7 days crdt") do
              response = client.search("long covid \"last 7 days\" [crdt]")
              expect(response).to be_a Net::HTTPOK
              expect(response.body).to include '2023/04/29'
            end
          end

          it "use [pa] for Pharmacological Action" do
            # https://pubmed.ncbi.nlm.nih.gov/help/#pa
            # To find actions: https://meshb.nlm.nih.gov/search?searchMethod=SubString&searchInField=termPharma&sort=&size=20&searchType=allWords&from=0&q=a
            VCR.use_cassette("search/reverse transcriptase inhibitors [pa]") do
              response = client.search("reverse transcriptase inhibitors [pa]")
              expect(response).to be_a Net::HTTPOK
              expect(response.body).to include "<QueryTranslation>\"reverse transcriptase inhibitors\"[Pharmacological Action]"
            end
          end

          it "use [ad] for Affiliation" do
            VCR.use_cassette("search/University of Glasgow [ad]") do
              response = client.search("University of Glasgow [ad]")
              expect(response).to be_a Net::HTTPOK
              expect(response.body).to include "<QueryTranslation>\"university of glasgow\"[Affiliation]"
            end
          end


          describe "title and abstract fields" do
            it "use [ti] for Title" do
              VCR.use_cassette("search/long covid [ti]") do
                response = client.search("long covid [ti]")
                expect(response).to be_a Net::HTTPOK
                expect(response.body).to include "<QueryTranslation>\"long covid\"[Title]"
              end
            end

            it "use [tiab] for Title/Abstract" do
              VCR.use_cassette("search/long covid [tiab]") do
                response = client.search("long covid [tiab]")
                expect(response).to be_a Net::HTTPOK
                expect(response.body).to include "<QueryTranslation>\"long covid\"[Title/Abstract]"
              end
            end

            it "allow proximity search by appending :~n" do
              VCR.use_cassette("search/covid treatment [tiab:~3]") do
                response = client.search("\"covid treatment\"[tiab:~3]")
                expect(response).to be_a Net::HTTPOK
                expect(response.body).to include "<QueryTranslation>\"covid treatment\"[Title/Abstract:~3]"
              end
            end
          end
        end
      end

      describe "optional parameters for retrieval" do
        # https://www.ncbi.nlm.nih.gov/books/NBK25499/#chapter4.ESearch

        it "rettype of :count" do
          VCR.use_cassette("search/MCAS [ti] rettype: :count") do
            response = client.search("MCAS", rettype: :count)
            expect(response).to be_a Net::HTTPOK
            expect(response.body).not_to include "<Id>"
            expect(response.body).to include "<Count>"
          end
        end

        it "retstart" do
          VCR.use_cassette("search/long covid retstart: 1000") do
            response = client.search("long covid", retstart: 1000)
            expect(response).to be_a Net::HTTPOK
            expect(response.body).to include "<RetStart>1000</RetStart>"
          end
        end

        it "retmax" do
          VCR.use_cassette("search/long covid retmax: 1000") do
            response = client.search("long covid", retmax: 1000)
            expect(response).to be_a Net::HTTPOK
            expect(response.body).to include "<RetMax>1000</RetMax>"
          end
        end

        it "retmode of :json" do
          VCR.use_cassette("search/prusty[au] retmode: :json") do
            response = client.search("prusty[au]", retmode: :json)
            expect(response).to be_a Net::HTTPOK
            expect(response).not_to include "<XML>"
          end
        end

        it "field" do
          VCR.use_cassette("search/covid field: title") do
            response = client.search("covid neuropathy", field: :title)
            expect(response).to be_a Net::HTTPOK
            expect(response.body).to include "<QueryTranslation>\"covid\"[Title] AND \"neuropathy\"[Title]"
          end
        end

        it "sort" do
          VCR.use_cassette("search/long covid sort: pub_date") do
            response = client.search("long covid", sort: :pub_date)
            expect(response).to be_a Net::HTTPOK
            # no way to verify in response
          end
        end
      end

      describe "optional parameters for dates" do
        it "takes a reldate" do
          VCR.use_cassette("search/long covid reldate: 1") do
            response = client.search("long covid", reldate: 1)
            expect(response).to be_a Net::HTTPOK
            expect(response.body).to include "[Date - Entry]</QueryTranslation>"
          end
        end

        it "takes a min/max date" do
          VCR.use_cassette("search/long covid mindate: 2022-12-25 maxdate: 2022-12-31") do
            response = client.search("long covid", mindate: "2022-12-25", maxdate: "2022-12-31")
            expect(response).to be_a Net::HTTPOK
            expect(response.body).to include "2022/12/25:2022/12/31[Date - Entry]"
          end
        end

        it "takes a datetype" do
          # https://dataguide.nlm.nih.gov/eutilities/utilities.html#esearch-date-filter-parameters
          VCR.use_cassette("search/long covid datetype: mdat, reldate: 1") do
            response = client.search("long covid", datetype: :crdt, reldate: 1)
            expect(response).to be_a Net::HTTPOK
            expect(response.body).to include "[Date - Create]</QueryTranslation>"
          end
        end
      end

      describe "optional parameters for the history server" do
      end
    end

    describe "fetch" do
      it "takes a single id" do
        VCR.use_cassette("fetch/36410718") do
          response = client.fetch(36410718)
          expect(response).to be_a Net::HTTPOK
          expect(response.body).to include "<PubmedArticle>"
          expect(response.body).to include "<PMID Version=\"1\">36410718</PMID>"
        end
      end

      it "takes an array of ids" do
        VCR.use_cassette("fetch/36410718 36460909") do
          response = client.fetch([36410718, 36460909])
          expect(response).to be_a Net::HTTPOK
          expect(response.body).to include("<PubmedArticle>").twice
          expect(response.body).to include "<PMID Version=\"1\">36410718</PMID>"
          expect(response.body).to include "<PMID Version=\"1\">36460909</PMID>"
        end
      end

      describe "optional parameters for retrieval" do
        describe "retmode" do
          it "can be text" do
            VCR.use_cassette("fetch/36410718 retmode text") do
              response = client.fetch(36410718, retmode: :text)
              expect(response).to be_a Net::HTTPOK
              expect(response.body).to eq "36410718\n"
            end
          end

          it "with explicit abstract rettype" do
            VCR.use_cassette("fetch/36410718 retmode text rettype abstract") do
              response = client.fetch(36410718, retmode: :text, rettype: :abstract)
              expect(response).to be_a Net::HTTPOK
              expect(response.body).to include "Nature. 2023 Jan;613(7944):565-574. doi: 10.1038/s41586-022-05555-7."
            end
          end
        end

        describe "rettype" do
          # the default rettype seems to be abstract
          # https://www.ncbi.nlm.nih.gov/books/NBK25499/table/chapter4.T._valid_values_of__retmode_and/?report=objectonly
          it "can be medline" do
            VCR.use_cassette("fetch/36410718 rettype medline") do
              response = client.fetch(36410718, rettype: :medline)
              expect(response).to be_a Net::HTTPOK
              expect(response.body).to include "PMID- 36410718\n"
              expect(response.body).to include "STAT- MEDLINE\n"
            end
          end

          it "can be uilist" do
            VCR.use_cassette("fetch/36410718 rettype uilist") do
              response = client.fetch(36410718, rettype: :uilist)
              expect(response).to be_a Net::HTTPOK
              expect(response.body).to eq "36410718\n"
            end
          end
        end
      end
    end
  end
end
