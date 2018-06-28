require 'connection_pool'
require 'fastimage'
require 'thread'
require 'faraday'
require 'faraday_middleware'
require 'base64'

module ProgImage
  class Client

    IMAGES_ENDPOINT = '/images'.freeze
    CONTENT_TYPE    = 'application/json'.freeze

    def initialize(pool_size: 3, timeout: 5)
      self.pool = ConnectionPool.new(size: pool_size, timeout: timeout) do
        Faraday.new(url: api_endpoint)
      end
    end

    def upload(urls)
      metadata = urls.map do |url|
        ProgImage::FileUpload.new(url)
      end

      metadata.map(&:join)

      response = pool.with do |client|
        client.post do |request|
          request.url IMAGES_ENDPOINT
          request.headers['Content-Type'] = CONTENT_TYPE
          request.body                    = JSON.generate(metadata.map(&:attributes))
        end
      end
      handle_response response
    end

    private
    attr_accessor :pool

    def api_endpoint
      "https://example.com"
    end

    def queue
      @queue ||= Queue.new
    end

    def handle_response(response)
      return JSON.parse(response) if response.success?
    end
  end
end
