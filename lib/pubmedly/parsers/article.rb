# frozen_string_literal: true

require "nokogiri"
require "date"

module Pubmedly
  module Parsers
    # The Article class provides methods to access Article data.
    class Article
      attr_reader :xml

      def initialize(xml)
        @xml = xml
      end

      def to_s
        "#{authors.first.split(",").first} (#{publication_date.year}) #{title}"
      end

      def title
        @xml.xpath(".//ArticleTitle").text
      end

      def publication_date
        date_str = @xml.xpath(".//PubDate").text
        begin
          date_str.empty? ? "" : Date.parse(date_str)
        rescue Date::Error
          Date.strptime(date_str.strip, "%Y")
        end
      end

      def abstract
        @xml.xpath(".//Abstract").text
      end

      def authors
        @xml.xpath(".//Author").map do |author|
          "#{author.xpath(".//LastName").text}, #{author.xpath(".//ForeName").text}"
        end
      end

      def pmid
        id = @xml.xpath(".//PMID").text.to_i
        id.zero? ? nil : id
      end
    end
  end
end
