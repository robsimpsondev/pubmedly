# Pubmedly

WIP

This gem provides a `Pubmedly::Client` with methods that get data from the NCBI's [Pubmed database](https://pubmed.ncbi.nlm.nih.gov/) using their [eutils APIs](https://www.ncbi.nlm.nih.gov/books/NBK25499/).

Furthermore, this gem provides a `Pubmedly::Pubmed` class that makes interacting with the eutils APIs easier by parsing responses using `Pubmedly::Parser` and providing a `Pubmedly::Article` class that wraps raw article data. The NCBI provide a _WebEnv_ identifier used to access and manipulate search results (identified by `query_key`s) saved to their History server, which is also supported.

You will need an API key to use this gem; how to do this is simple and introduced with context [here](https://www.ncbi.nlm.nih.gov/books/NBK25497/).

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

## Usage

`Pubmedly::Client` has methods synonymous with the NCBI's eutils API, and the raw web responses are returned with data in XML (default) or JSON.

```ruby
client = Pubmedly::Client.new("<YOUR_NCBI_API_KEY>")
client.search("Bifidobacterium longum", retmax: 10)
# todo add raw response
```

`Pubmedly::Pubmed` wraps the NCBI API methods implemented in `Pubmedly::Client` to make getting useful results more straightforward.

```ruby
pubmed = Pubmedly::Client.new("<YOUR_NCBI_API_KEY>")
ids, count = pubmed.search("Bifidobacterium longum", retmax: 10, sort: "pub_date")
count      = pubmed.search("covid AND small intestine AND 2023[pdate]", rettype: count)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pubmedly. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/pubmedly/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pubmedly project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pubmedly/blob/main/CODE_OF_CONDUCT.md).
