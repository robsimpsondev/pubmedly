# frozen_string_literal: true

require "net/http"
require "json"
require "nokogiri"

module Pubmedly
  class Pubmed

    def initialize(api_key)
      @client = Client.new(api_key)
    end

    def search(...)
      Parser.new(client.search(...)).ids
    end
  end
end
