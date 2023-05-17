# frozen_string_literal: true

require_relative "lib/pubmedly/version"

Gem::Specification.new do |spec|
  spec.name = "pubmedly"
  spec.version = Pubmedly::VERSION
  spec.authors = ["Rob Simpson"]
  spec.email = ["robsimpsondev@gmail.com"]

  spec.summary = "Ruby client for the NCBI eutils Pubmed API"
  spec.description = "Search the NIH database for medical research."
  spec.homepage = "https://github.com/robsimpsondev?tab=repositories&q=&type=public&language=&sort="
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/robsimpsondev/pubmedly"
  spec.metadata["changelog_uri"] = "https://github.com/robsimpsondev/pubmedly/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-reload"
  spec.add_development_dependency "os"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
