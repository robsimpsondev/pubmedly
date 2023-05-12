# frozen_string_literal: true

module Pubmedly
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
