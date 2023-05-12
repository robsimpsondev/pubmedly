# frozen_string_literal: true

# Provides a Ruby client for accessing the NCBI's Pubmed database through the eutils API.
# The NCBI eutils API provides access to many databases, but these out of the scope of pubmedly:
# https://www.ncbi.nlm.nih.gov/books/NBK25497/table/chapter2.T._entrez_unique_identifiers_ui/?report=objectonly

require "net/http"

module Pubmedly
  class Client
    BASE_URL = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/"
    NCBI_DB  = "pubmed"

    def initialize(api_key)
      @api_key = api_key
    end

    def search(term, **kwargs)
      # https://www.ncbi.nlm.nih.gov/books/NBK25499/#chapter4.ESearch
      # For guidance on search terms: https://pubmed.ncbi.nlm.nih.gov/help/#how-do-i-search-pubmed
      # To understand term mapping:   https://pubmed.ncbi.nlm.nih.gov/help/#automatic-term-mapping
      # List of all field tags:       https://pubmed.ncbi.nlm.nih.gov/help/#search-tags
      # Parameters for retrieval:     https://www.ncbi.nlm.nih.gov/books/NBK25499/#chapter4.ESearch
      # datetype parameter options:   https://dataguide.nlm.nih.gov/eutilities/utilities.html#esearch-date-filter-parameters

      url  = URI.parse("#{BASE_URL}esearch.fcgi")

      params = kwargs.merge({
        db:       NCBI_DB,
        api_key:  @api_key,
        term:     term,
      })

      url.query = URI.encode_www_form(params)

      http         = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      http.request(Net::HTTP::Get.new(url.request_uri))
    end

    def fetch(ids, **kwargs)
      # https://www.ncbi.nlm.nih.gov/books/NBK25499/#chapter4.EFetch

      ids = [ids] unless ids.is_a? Array

      url = URI.parse("#{BASE_URL}efetch.fcgi")

      params = kwargs.merge(
        db:       NCBI_DB,
        api_key:  @api_key,
        id: ids.join(",")
      )

      url.query = URI.encode_www_form(params)

      http         = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      http.request(Net::HTTP::Get.new(url.request_uri))
    end
  end
end
