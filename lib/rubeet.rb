# frozen_string_literal: true

require_relative "rubeet/version"
require_relative "rubeet/crawler"
require_relative "rubeet/core"

# module Rubeet
module Rubeet
  class Error < StandardError; end
  class CrawlerError < Error; end
  class ParseError < Error; end
  class NetworkError < Error; end

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

    def reset
      self.configuration = Configuration.new
    end
  end
end
