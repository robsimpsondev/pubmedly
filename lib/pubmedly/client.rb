# frozen_string_literal: true

require "net/http"
require "json"

module Pubmedly
  class PubmedClient
    BASE_URL = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/"

    def initialize(api_key)
      @api_key = api_key
    end

    def search(query, options = {})
      db       = options.fetch(:db, "pubmed")
      retmax   = options.fetch(:retmax, 10)
      retstart = options.fetch(:retstart, 0)
      sort     = options.fetch(:sort, "relevance")
      fields   = options.fetch(:fields, "id,title,abstract")
      summary  = options.fetch(:summary, "short")

      url  = URI.parse("#{BASE_URL}esearch.fcgi")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      params = {
        "db" => db,
        "term" => query,
        "retmax" => retmax,
        "retstart" => retstart,
        "sort" => sort,
        "fields" => fields,
        "api_key" => @api_key,
        "summary" => summary
      }
      url.query = URI.encode_www_form(params)
      response  = http.request(Net::HTTP::Get.new(url.request_uri))

      raise "Error: #{response.code} - #{response.body}" if response.code != "200"

      response.body
    end
  end
end
