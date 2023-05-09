# frozen_string_literal: true

require "nokogiri"

module Pubmedly
  class Parser

    def initialize(response)
      @xml = Nokogiri::XML(response.body)
    end

    def count
      @xml.xpath(".//Count").text.to_i
    end

    def ids
      @xml.xpath(".//Id").map(&:text).map(&:to_i).to_a
    end
  end
end
