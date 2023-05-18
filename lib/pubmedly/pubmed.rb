# frozen_string_literal: true

module Pubmedly
  # The Pubmed class is the main entry point for the gem. It is initialized
  # with an NCBI API key and exposes methods for searching and fetching
  # articles.
  #
  # @example
  #   pubmed = Pubmedly::Pubmed.new("my_api_key")
  #   pubmed.search("cancer")    # returns an array of Pubmed IDs
  #   pubmed.fetch(37194105)     # returns an array of Articles
  #   pubmed.articles("cancer")  # returns an array of Articles
  #
  class Pubmed
    def initialize(api_key)
      @client = Client.new(api_key)
    end

    def search(...)
      Parsers::Response.new(@client.search(...)).ids
    end

    def fetch(...)
      Parsers::Response.new(@client.fetch(...)).articles
    end

    def articles(term, **kwargs)
      fetch(search(term, **kwargs), **kwargs)
    end
  end
end
