# frozen_string_literal: true

require_relative "rubeet/version"
require_relative "rubeet/crawler"
require_relative "rubeet/response"
require_relative "rubeet/core"

# Main module for the Rubeet web crawling framework.
# Provides a high-level interface for configuring and executing web crawlers
# with built-in support for concurrent requests, data extraction, and pipeline processing.
#
# @example Basic usage
#   Rubeet.configure do |config|
#     config.user_agent = "MyBot/1.0"
#     config.concurrent_requests = 3
#   end
module Rubeet
  # Base error class for all Rubeet-specific errors.
  # All custom errors in the framework inherit from this class.
  class Error < StandardError; end

  # Raised when the crawler encounters an error during the crawling process.
  # This includes issues with request handling, response processing, or
  # general crawler operations.
  #
  # @example
  #   raise CrawlerError.new("Failed to process page: invalid encoding")
  class CrawlerError < Error; end

  # Raised when HTML/XML parsing fails.
  # This typically occurs when the response content cannot be properly parsed
  # or when specified selectors cannot be applied.
  #
  # @example
  #   raise ParseError.new("Invalid HTML structure in response")
  class ParseError < Error; end

  # Raised when network-related issues occur.
  # This includes connection timeouts, DNS resolution failures,
  # and other network connectivity problems.
  #
  # @example
  #   raise NetworkError.new("Connection timed out after 30 seconds")
  class NetworkError < Error; end

  class << self
    # Global configuration instance for the Rubeet framework.
    # Stores all configuration settings that apply across the framework.
    #
    # @return [Rubeet::Core::Configuration] The global configuration instance
    attr_accessor :configuration

    # Configures global settings for the Rubeet framework.
    # Yields a configuration object for setting up crawler behavior.
    # If no block is given, returns the current configuration.
    #
    # @yield [config] Configuration instance for setting up the framework
    # @yieldparam config [Rubeet::Core::Configuration] The configuration instance
    # @return [Rubeet::Core::Configuration] The current configuration instance
    #
    # @example Configuring basic settings
    #   Rubeet.configure do |config|
    #     config.user_agent = "MyBot/1.0"
    #     config.concurrent_requests = 3
    #     config.delay = 1.0
    #   end
    def configure
      self.configuration ||= Core::Configuration.new
      yield(configuration) if block_given?
      configuration
    end

    # Resets the global configuration to default values.
    # This is particularly useful in testing environments where
    # you want to ensure a clean configuration state.
    #
    # @return [Rubeet::Core::Configuration] A new configuration instance with default values
    #
    # @example
    #   # In a test setup
    #   before(:each) do
    #     Rubeet.reset
    #   end
    def reset
      self.configuration = Core::Configuration.new
    end
  end
end
