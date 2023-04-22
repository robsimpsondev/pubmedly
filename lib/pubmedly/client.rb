# frozen_string_literal: true

require "net/http"
require "json"
require "nokogiri"

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

    def fetch(pubmed_ids)
      url = "#{BASE_URL}/efetch.fcgi?db=pubmed&id=#{pubmed_ids.join(',')}&rettype=xml&retmode=xml"

      response = Net::HTTP.get_response(URI.parse(url))

      raise "Error: #{response.code} - #{response.body}" if response.code != "200"
      
      xml_response = response.body

      # Parse the XML response using Nokogiri
      doc = Nokogiri::XML(xml_response)

      # Extract relevant information from the parsed XML response
      articles = []
      pubmed_articles = doc.xpath('//PubmedArticle')

      pubmed_articles.each do |pubmed_article|
        article = {}
        article['title'] = pubmed_article.xpath('.//ArticleTitle').text
        article['abstract'] = pubmed_article.xpath('.//Abstract/AbstractText').text
        article['authors'] = pubmed_article.xpath('.//AuthorList/Author').map do |author|
          author.xpath('.//LastName').text + ' ' + author.xpath('.//Initials').text
        end
        # ... add more fields as needed ...
        articles << article
      end

      articles
    end
  end
end
