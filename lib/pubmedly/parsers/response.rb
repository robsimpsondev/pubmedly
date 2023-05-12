# frozen_string_literal: true

require "nokogiri"

module Pubmedly
  module Parsers
    class Response

      def initialize(response)
        @xml = Nokogiri::XML(response.body)
      end

      def count
        @xml.xpath(".//Count").text.to_i
      end

      def ids
        @xml.xpath(".//Id").map(&:text).map(&:to_i).to_a
      end

      def articles
        @xml.xpath(".//Article").map do |article_xml|
          Pubmedly::Parsers::Article.new(article_xml)
        end
      end
    end
  end
end
