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
    context "when all required settings are provided" do
      it "creates a new instance successfully" do
        crawler_class = create_crawler_class do
          domain "example.com"
          start_urls ["https://example.com"]
        end

        expect { crawler_class.new }.not_to raise_error
      end

      it "inherits settings from the class level" do
        crawler_class = create_crawler_class do
          domain "example.com"
          start_urls ["https://example.com"]
        end

        instance = crawler_class.new
        expect(instance.domain).to eq("example.com")
        expect(instance.start_urls).to eq(["https://example.com"])
      end
    end

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

  describe ".start_urls" do
    it "sets the starting URLs for the crawler" do
      crawler_class = create_crawler_class do
        domain "example.com"
        start_urls ["https://example.com/page1", "https://example.com/page2"]
      end

      expect(crawler_class.instance_variable_get(:@start_urls)).to eq(
        ["https://example.com/page1", "https://example.com/page2"]
      )
    end

    it "accepts a single URL as a string" do
      crawler_class = create_crawler_class do
        domain "example.com"
        start_urls "https://example.com/page1"
      end

      expect(crawler_class.instance_variable_get(:@start_urls)).to eq(
        ["https://example.com/page1"]
      )
    end

    it "raises an error when no URLs are provided" do
      expect do
        create_crawler_class do
          domain "example.com"
          start_urls []
        end
      end.to raise_error(ArgumentError, "At least one start URL must be provided")
    end

    it "warns about URLs not starting with http(s)://" do
      expect do
        create_crawler_class do
          domain "example.com"
          start_urls ["ftp://example.com"]
        end
      end.to output(%r{Warning: URL 'ftp://example.com' should start with http:// or https://}).to_stderr
    end

    it "returns the processed array of URLs" do
      crawler_class = create_crawler_class do
        domain "example.com"
        @result = start_urls(["https://example.com/page1"])
      end

      expect(crawler_class.instance_variable_get(:@result)).to eq(
        ["https://example.com/page1"]
      )
    end

    it "allows URLs to be accessed after initialization" do
      crawler_class = create_crawler_class do
        domain "example.com"
        start_urls ["https://example.com/page1"]
      end

      instance = crawler_class.new
      expect(instance.start_urls).to eq(["https://example.com/page1"])
    end
  end

  describe ".parse" do
    let(:mock_parser) { double("Parser") }

    before do
      # この時点ではParserクラスはまだ実装されていないため、
      # モックを使用してパーサーの動作をシミュレートします
      stub_const("Rubeet::Parser", double("ParserClass"))
      allow(Rubeet::Parser).to receive(:new).and_return(mock_parser)
    end

    it "registers a parser with the given name" do
      crawler_class = create_crawler_class do
        domain "example.com"
        start_urls ["https://example.com"]
        parse :product do |response|
          # パース処理
        end
      end

      expect(crawler_class.parsers).to have_key(:product)
    end

    it "creates a new parser with the provided options" do
      expect(Rubeet::Parser).to receive(:new).with(
        hash_including(
          name: :product,
          options: { priority: 1 }
        )
      )

      create_crawler_class do
        domain "example.com"
        start_urls ["https://example.com"]
        parse :product, priority: 1 do |response|
          # パース処理
        end
      end
    end

    it "allows multiple parsers to be registered" do
      crawler_class = create_crawler_class do
        domain "example.com"
        start_urls ["https://example.com"]

        parse :category do |response|
          # カテゴリーページのパース処理
        end

        parse :product do |response|
          # 商品ページのパース処理
        end
      end

      expect(crawler_class.parsers.keys).to contain_exactly(:category, :product)
    end
  end
end
