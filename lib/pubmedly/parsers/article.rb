# frozen_string_literal: true

require "nokogiri"
require "date"

module Pubmedly
  module Parsers
    class Article
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def title
        @xml.xpath(".//ArticleTitle").text
      end

      def publication_date
        Date.parse(@xml.xpath(".//PubDate").text)
      end

      def abstract
        @xml.xpath(".//Abstract").text
      end
    end
  end
end
