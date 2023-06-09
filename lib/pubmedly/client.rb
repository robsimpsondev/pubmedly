# frozen_string_literal: true

require "net/http"

module Pubmedly
  # The Client class provides methods for accessing the NCBI's eutils Pubmed API that
  # return HTTP objects.
  #
  # The NCBI eutils API provides access to many databases, but these out of the scope of pubmedly:
  #   https://www.ncbi.nlm.nih.gov/books/NBK25497/table/chapter2.T._entrez_unique_identifiers_ui/?report=objectonly
  class Client
    BASE_URL = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/"
    NCBI_DB  = "pubmed"

    def initialize(api_key)
      @api_key = api_key
    end

    # https://www.ncbi.nlm.nih.gov/books/NBK25499/#chapter4.ESearch
    # For guidance on search terms: https://pubmed.ncbi.nlm.nih.gov/help/#how-do-i-search-pubmed
    # To understand term mapping:   https://pubmed.ncbi.nlm.nih.gov/help/#automatic-term-mapping
    # List of all field tags:       https://pubmed.ncbi.nlm.nih.gov/help/#search-tags
    # Parameters for retrieval:     https://www.ncbi.nlm.nih.gov/books/NBK25499/#chapter4.ESearch
    # datetype parameter options:   https://dataguide.nlm.nih.gov/eutilities/utilities.html#esearch-date-filter-parameters
    def search(term, **kwargs)
      url = URI.parse("#{BASE_URL}esearch.fcgi")

      params = kwargs.merge({
        db:      NCBI_DB,
        api_key: @api_key,
        term:    term,
      })

      url.query = URI.encode_www_form(params)

      http         = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      http.request(Net::HTTP::Get.new(url.request_uri))
    end

    # https://www.ncbi.nlm.nih.gov/books/NBK25499/#chapter4.EFetch
    def fetch(*ids, **kwargs)
      url = URI.parse("#{BASE_URL}efetch.fcgi")

      params = kwargs.merge(
        db:      NCBI_DB,
        api_key: @api_key,
        id:      ids.join(",")
      )

      url.query = URI.encode_www_form(params)

      http         = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      http.request(Net::HTTP::Get.new(url.request_uri))
    end
  end
end
