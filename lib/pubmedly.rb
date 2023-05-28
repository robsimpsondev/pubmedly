# frozen_string_literal: true

require_relative "pubmedly/version"
require_relative "pubmedly/client"
require_relative "pubmedly/parsers/article"
require_relative "pubmedly/parsers/response"
require_relative "pubmedly/pubmed"

module Pubmedly
  class ApiWarning < StandardError; end
  # Your code goes here...

  # https://pubmed.ncbi.nlm.nih.gov/help/#search-tags
  FIELD_TAGS = {
    "Affiliation" => ["ad"],
    "All Fields" => ["all"],
    "Article Identifier" => ["aid"],
    "Author" => ["au"],
    "Author Identifier" => ["auid"],
    "Book" => ["book"],
    "Completion Date" => ["dcom"],
    "Conflict of Interest Statement" => ["cois"],
    "Corporate Author" => ["cn"],
    "Create Date" => ["crdt"],
    "EC/RN Number" => ["rn"],
    "Editor" => ["ed"],
    "Entry Date" => ["edat"],
    "Filter" => %w[filter sb],
    "First Author Name" => ["1au"],
    "Full Author Name" => ["fau"],
    "Full Investigator Name" => ["fir"],
    "Grant Number" => ["gr"],
    "Investigator" => ["ir"],
    "ISBN" => ["isbn"],
    "Issue" => ["ip"],
    "Journal" => ["ta"],
    "Language" => ["la"],
    "Last Author Name" => ["lastau"],
    "Location ID" => ["lid"],
    "MeSH Date" => ["mhda"],
    "MeSH Major Topic" => ["majr"],
    "MeSH Subheadings" => ["sh"],
    "MeSH Terms" => ["mh"],
    "Modification Date" => ["lr"],
    "NLM Unique ID" => ["jid"],
    "Other Term" => ["ot"],
    "Pagination" => ["pg"],
    "Personal Name as Subject" => ["ps"],
    "Pharmacological Action" => ["pa"],
    "Place of Publication" => ["pl"],
    "PMID" => ["pmid"],
    "Publication Date" => ["dp"],
    "Publication Type" => ["pt"],
    "Publisher" => ["pubn"],
    "Secondary Source ID" => ["si"],
    "Subset" => ["sb"],
    "Supplementary Concept" => ["nm"],
    "Text Words" => ["tw"],
    "Title" => ["ti"],
    "Title/Abstract" => ["tiab"],
    "Transliterated Title" => ["tt"],
    "Volume" => ["vi"],
  }.freeze
end
