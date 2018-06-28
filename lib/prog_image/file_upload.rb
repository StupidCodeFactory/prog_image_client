module ProgImage
  class FileUpload
    attr_reader :size, :type, :orientation, :content_length

    def initialize(url)
      self.url = url
      download_worker
      metadata_worker
    end

    def join
      download_worker.join
    end


    def data
      @data ||= "data:image/#{type};base64 #{Base64.urlsafe_encode64(raw_data)}"
    end

    def attributes
      {
          size:           size,
          type:           type,
          orientation:    orientation,
          content_length: content_length
      }
    end

    private
    attr_accessor :url, :raw_data
    attr_writer :size, :type, :orientation, :content_length, :data

    def metadata_worker
      @metadata_worker ||= Thread.new do
        mutex.synchronize do
          self.size           = fastimage.size
          self.type           = fastimage.type
          self.orientation    = fastimage.orientation
          self.content_length = fastimage.content_length
        end
      end
    end

    def download_worker
      @dowload_worker ||= Thread.new do
        mutex.synchronize do
          self.raw_data = connection.get(url).body
        end
      end
    end

    def fastimage
      @fastimage ||= FastImage.new(url)
    end

    def connection
      @connection ||= Faraday.new(url) do |conn|
        conn.use FaradayMiddleware::FollowRedirects
        conn.adapter :typhoeus
      end
    end

    def mutex
      @mutex ||= Mutex.new
    end
  end
end
