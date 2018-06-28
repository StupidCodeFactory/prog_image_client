require "spec_helper"

RSpec.describe ProgImage::Client do
  let(:default_pool_size) { 3 }
  let(:default_timeout)   { 5 }

  describe '.new' do
    it 'sets up a connection pool with default values' do
      expect(ConnectionPool).to receive(:new).with(size: default_pool_size, timeout: default_timeout)
      described_class.new
    end

  end

  describe '#upload' do
    let(:urls) do
      {
        "https://picsum.photos/200/300/?random" => image_one,
        "https://picsum.photos/100/400/?random" => image_two,
        "https://picsum.photos/200/200/?random" => image_three
      }
    end

    describe 'when using a bunche of urls', vcr: { cassette_name: :multipe_images } do

      let(:image_one) do
        { type: 1, size: 1, content_type: :jpeg, data: 'base64_encoded', orientation: 1 }
      end

      let(:image_two) do
        { type: 2, size: 2, content_type: :jpeg, data: 'base64_encoded', orientation: 2 }
      end

      let(:image_three) do
        { type: 3, size: 3, content_type: :jpeg, data: 'base64_encoded', orientation: 3 }
      end

      it 'fetches metadata about give images' do
        urls.each do |url, attributes|
          double = double(ProgImage::FileUpload, join: nil, attributes: attributes)
          expect(ProgImage::FileUpload).to receive(:new).and_return(double)
          expect(double).to receive(:join)
        end

        subject.upload(urls)
      end
    end
  end
end
