# frozen_string_literal: true

require_relative "lib/rubeet/version"

Gem::Specification.new do |spec|
  spec.name = "rubeet"
  spec.version = Rubeet::VERSION
  spec.authors = ["Mikiyasu Obara"]
  spec.email = ["mikiyasu.obara@prominence-inc.co.jp"]

  spec.summary = "A Ruby web crawling framework inspired by Scrapy"
  spec.description = "Rubeet is a fast and powerful web crawling framework for Ruby, " \
                    "designed with Ruby's elegance in mind. It provides a DSL for " \
                    "defining crawlers, with built-in support for concurrent requests, " \
                    "data extraction, and pipeline processing."
  spec.homepage = "https://github.com/phyten/rubeet"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
