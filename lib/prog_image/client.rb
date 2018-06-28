require 'connection_pool'
require 'fastimage'

module ProgImage
  class Client

    def initialize(pool_size: 3, timeout: 5)
      self.pool = ConnectionPool.new(size: pool_size, timeout: timeout) do
         Faraday.new(url: api_endpoint)
      end
    end

    private
    attr_accessor :pool

    def api_endpoint
      "https://example.com"
    end
  end
end
