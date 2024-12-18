# frozen_string_literal: true

require "spec_helper"

RSpec.describe Rubeet::Crawler::Base do
  # helper method to create a new crawler class with a block
  def create_crawler_class(&block)
    Class.new(described_class, &block)
  end

  describe ".domain" do
    it "sets the domain for the crawler" do
      crawler_class = create_crawler_class do
        domain "example.com"
      end

      # check that the domain was set correctly
      expect(crawler_class.instance_variable_get(:@domain)).to eq("example.com")
    end
  end

  describe "#initialize" do
    context "when domain is not set" do
      it "raises an error" do
        crawler_class = create_crawler_class {}

        expect { crawler_class.new }
          .to raise_error(Rubeet::CrawlerError, "Domain must be specified")
      end
    end

    context "when start_urls are not set" do
      it "raises an error" do
        crawler_class = create_crawler_class do
          domain "example.com"
        end

        expect { crawler_class.new }
          .to raise_error(Rubeet::CrawlerError, "Start URLs must be specified")
      end
    end
  end
end
