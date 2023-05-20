# Pubmedly

This gem provides a `Pubmedly::Client` with methods that get data from the NCBI's [Pubmed database](https://pubmed.ncbi.nlm.nih.gov/) using their [eutils APIs](https://www.ncbi.nlm.nih.gov/books/NBK25499/).

Furthermore, this gem provides a `Pubmedly::Pubmed` class that makes interacting with the eutils APIs easier by parsing the XML responses into useful Ruby objects.

You will need an API key to use this gem; doing this is simple and described with context [here](https://www.ncbi.nlm.nih.gov/books/NBK25497/).

## Installation

Requirements:
 - Ruby 3.0+

Install the gem and add to the application's Gemfile by executing:

    $ bundle add pubmedly

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install pubmedly

## Usage

`Pubmedly::Client` has methods synonymous with the NCBI's eutils API, and the raw web responses are returned with data in XML (default) or JSON.

```ruby
client = Pubmedly::Client.new("<YOUR_NCBI_API_KEY>")
#<Pubmedly::Client:0x00000001089768d8 @api_key="<YOUR_NCBI_API_KEY>">

response = client.search("Bifidobacterium longum", retmax: 10)
#<Net::HTTPOK 200 OK readbody=true>

puts response.body
#<?xml version="1.0" encoding="UTF-8" ?>
#<!DOCTYPE eSearchResult PUBLIC "-//NLM//DTD esearch 20060628//EN" "https://eutils.ncbi.nlm.nih.gov/eutils/dtd/20060628/esearch.dtd">
#<eSearchResult><Count>2321</Count><RetMax>10</RetMax><RetStart>0</RetStart><IdList>
#<Id>37180228</Id>
#<Id>37176158</Id>
#<Id>37175970</Id>
#<Id>37174650</Id>
#<Id>37172455</Id>
# ...

response = client.fetch(37180228)
#<Net::HTTPOK 200 OK readbody=true>

puts response.body
#<?xml version="1.0" ?>
#<!DOCTYPE PubmedArticleSet PUBLIC "-//NLM//DTD PubMedArticle, 1st January 2023//EN" "https://dtd.nlm.nih.gov/ncbi/pubmed/out/pubmed_230101.dtd">
#<PubmedArticleSet>
#  <PubmedArticle>
#    <MedlineCitation Status="PubMed-not-MEDLINE" Owner="NLM" IndexingMethod="Automated">
#      <PMID Version="1">37180228</PMID>
# ...
```

`Pubmedly::Pubmed` wraps the NCBI API methods implemented in `Pubmedly::Client` to make the return types more useful.

```ruby
pubmed = Pubmedly::Pubmed.new("<YOUR_NCBI_API_KEY>")
#<Pubmedly::Pubmed:0x0000000108a97d20 @client=#<Pubmedly::Client:0x0000000108a97c58 @api_key="<YOUR_NCBI_API_KEY>">>

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. for convenience the console will initialize with `@client` and `@pubmed` objects if `NCBI_API_KEY` is defined in your environment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/robsimpsondev/pubmedly. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/robsimpsondev/pubmedly/blob/main/CODE_OF_CONDUCT.md).

With write access to the `main` branch one can release a new version by updating the version number in `version.rb`, and running `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Versioning

This project uses [Semantic Versioning](https://semver.org/).

Given a version number MAJOR.MINOR.PATCH, increment the:

 - MAJOR version when you make incompatible API changes
 - MINOR version when you add functionality in a backward compatible manner
 - PATCH version when you make backward compatible bug fixes

Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pubmedly project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/robsimpsondev/pubmedly/blob/main/CODE_OF_CONDUCT.md).
