# frozen_string_literal: true

module Rubeet
  # HTTP レスポンスを表すシンプルなクラス
  class Response
    attr_reader :uri, :body, :status, :headers

    # @param uri [URI] リクエストした URI
    # @param body [String] レスポンスボディ
    # @param status [Integer] HTTP ステータスコード
    # @param headers [Hash] レスポンスヘッダー
    def initialize(uri:, body:, status:, headers: {})
      @uri = uri
      @body = body
      @status = status
      @headers = headers
    end
  end
end
