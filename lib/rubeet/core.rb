# frozen_string_literal: true

module Rubeet
  # Core functionality for the Rubeet framework.
  # Provides configuration and basic utilities used throughout the framework.
  module Core
    # Manages crawler configuration settings.
    # Provides centralized configuration for request handling,
    # error management, and logging behavior.
    class Configuration
      # User agent string used to identify the crawler
      # @return [String] the user agent string
      attr_accessor :user_agent

      # Whether to follow HTTP redirects
      # @return [Boolean] true if redirects should be followed
      attr_accessor :follow_redirects

      # Maximum number of redirects to follow
      # @return [Integer] maximum redirect count
      attr_accessor :max_redirects

      # Whether to respect robots.txt rules
      # @return [Boolean] true if robots.txt should be respected
      attr_accessor :respect_robots_txt

      # Number of concurrent requests allowed
      # @return [Integer] maximum concurrent requests
      attr_accessor :concurrent_requests

      # Request timeout in seconds
      # @return [Integer] timeout value in seconds
      attr_accessor :request_timeout

      # Delay between requests in seconds
      # @return [Float] delay value in seconds
      attr_accessor :delay

      # Maximum number of retry attempts
      # @return [Integer] maximum retry count
      attr_accessor :max_retries

      # Wait time between retries in seconds
      # @return [Integer] retry wait time in seconds
      attr_accessor :retry_wait_time

      # Logger instance for crawler events
      # @return [Logger] configured logger instance
      attr_accessor :logger

      # Log level for the crawler
      # @return [Symbol] log level (:debug, :info, :warn, :error)
      attr_accessor :log_level

      # Initializes a new Configuration instance with default values
      # @return [Configuration] New configuration instance with default settings
      def initialize
        set_default_values
      end

      private

      # Sets up the default configuration values for all settings.
      # This method initializes sensible defaults that work well for
      # most crawling scenarios while being respectful to target servers.
      #
      # @private
      def set_default_values
        @user_agent = "Rubeet/#{Rubeet::VERSION} (+https://github.com/phyten/rubeet)"
        @follow_redirects = true
        @max_redirects = 5
        @respect_robots_txt = true
        @concurrent_requests = 5
        @request_timeout = 30
        @delay = 0
        @max_retries = 3
        @retry_wait_time = 5
        @logger = default_logger
        @log_level = :info
      end

      # Creates and configures a default logger instance.
      # The logger outputs to STDOUT with a custom format that includes
      # timestamp, severity, and a Rubeet prefix.
      #
      # @return [Logger] configured logger instance
      # @private
      def default_logger
        require "logger"
        Logger.new($stdout).tap do |logger|
          logger.level = Logger::INFO
          logger.formatter = proc do |severity, datetime, _progname, msg|
            "#{datetime} [#{severity}] Rubeet: #{msg}\n"
          end
        end
      end
    end
  end
end
