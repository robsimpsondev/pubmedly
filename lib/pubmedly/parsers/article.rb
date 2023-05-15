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
        date_str = @xml.xpath(".//PubDate").text
        date_str.empty? ? "" : Date.parse(date_str)
      end

      def abstract
        @xml.xpath(".//Abstract").text
      end
    end
  end
end
