# frozen_string_literal: true

module Rubeet
  module Crawler
    # Base class for all crawlers in the Rubeet framework.
    # Provides core crawling functionality and DSL methods for defining
    # crawling behavior.
    class Base
      # @return [String] The domain this crawler is restricted to
      attr_reader :domain

      # @return [Array<String>] List of URLs to start crawling from
      attr_reader :start_urls

      class << self
        # Sets the domain for this crawler.
        # The crawler will only process URLs within this domain.
        #
        # @param value [String] The domain to restrict crawling to
        # @return [void]
        #
        # @example
        #   domain "example.com"
        def domain(value)
          @domain = value
        end

        # Sets the initial URLs for the crawler to start from.
        # These URLs will be the first ones processed when crawling begins.
        # Accepts either a single URL as a string or an array of URLs.
        #
        # @param urls [String, Array<String>] Single URL or list of URLs to start crawling from
        # @return [Array<String>] The processed array of URLs
        # @raise [ArgumentError] If no URLs are provided
        #
        # @example Setting multiple URLs
        #   start_urls ["https://example.com/page1", "https://example.com/page2"]
        #
        # @example Setting a single URL
        #   start_urls "https://example.com/page1"
        #
        # @example Invalid URL format will trigger a warning
        #   start_urls ["ftp://example.com"]  # => Warning: URL should start with http:// or https://
        def start_urls(urls)
          @start_urls = Array(urls)

          # Validate that at least one start URL is provided
          raise ArgumentError, "At least one start URL must be provided" if @start_urls.empty?

          # Warn if any start URLs are missing the http:// or https:// prefix
          @start_urls.each do |url|
            warn "Warning: URL '#{url}' should start with http:// or https://" unless url.match?(%r{\Ahttps?://})
          end

          @start_urls
        end

        # Defines a parser method for processing responses.
        # Uses a DSL approach to make parser definitions more declarative and
        # easier to understand.
        #
        # @param name [Symbol] Name of the parser method
        # @param options [Hash] Additional options for the parser
        # @option options [Integer] :priority Priority of this parser (default: 0)
        # @option options [Boolean] :follow_links Whether to extract and follow links (default: true)
        # @yield [response] Block that processes the response
        # @yieldparam response [Response] Response object containing the page content
        # @yieldreturn [Hash, Array<Hash>] Extracted data
        #
        # @example Define a parser for product pages
        #   parse :product, priority: 1 do |response|
        #     {
        #       title: response.css('.product-title').text,
        #       price: response.css('.product-price').text
        #     }
        #   end
        def parse(name, **options, &block)
          parsers[name] = Parser.new(
            name: name,
            options: options,
            block: block
          )
        end

        # @return [Hash{Symbol => Parser}] Registry of defined parsers
        def parsers
          @parsers ||= {}
        end
      end

      # Initializes a new crawler instance
      #
      # @param config [Configuration] Optional custom configuration
      def initialize(config = Rubeet.configuration)
        @config = config
        @domain = self.class.instance_variable_get(:@domain)
        @start_urls = self.class.instance_variable_get(:@start_urls)
        validate_configuration!
      end

      # Starts the crawling process
      #
      # @return [void]
      def crawl
        start_urls.each do |url|
          process_url(url)
        end
      end

      private

      # Validates the crawler's configuration
      #
      # @raise [CrawlerError] If required configuration is missing
      # @private
      def validate_configuration!
        raise CrawlerError, "Domain must be specified" if domain.nil?
        raise CrawlerError, "Start URLs must be specified" if start_urls.nil? || start_urls.empty?
      end

      # Processes a single URL
      #
      # @param url [String] The URL to process
      # @return [void]
      # @private
      def process_url(url)
        response = fetch_url(url)
        parser = find_parser_for(url)
        parser.call(response)
      rescue NetworkError => e
        @config.logger.error "Failed to fetch URL #{url}: #{e.message}"
      rescue ParseError => e
        @config.logger.error "Failed to parse URL #{url}: #{e.message}"
      end

      # Fetches content from a URL
      #
      # @param url [String] The URL to fetch
      # @return [Response] Response object containing the page content
      # @raise [NetworkError] If the URL cannot be fetched
      # @private
      def fetch_url(url)
        # この部分は後でHTTPクライアントの実装時に実装します
        raise NotImplementedError, "fetch_url method must be implemented"
      end

      # Finds the appropriate parser for a URL
      #
      # @param url [String] The URL to find a parser for
      # @return [Parser] The parser to use for this URL
      # @raise [CrawlerError] If no parser can be found
      # @private
      def find_parser_for(url)
        # この部分は後でURLパターンマッチングの実装時に実装します
        raise NotImplementedError, "find_parser_for method must be implemented"
      end
    end
  end
end
