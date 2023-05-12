# frozen_string_literal: true

require_relative "pubmedly/version"
require_relative "pubmedly/client"
require_relative "pubmedly/parsers/article"
require_relative "pubmedly/parsers/response"
require_relative "pubmedly/pubmed"

module Pubmedly
  class ApiWarning < StandardError; end
  # Your code goes here...
end
