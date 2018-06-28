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
      %w(
        https://picsum.photos/200/300/?random
        https://picsum.photos/100/400/?random
        https://picsum.photos/200/200/?random
      )
    end

    describe 'when using a bunche of urls' do
      it 'fetches metadata about give images' do
        expect(FastImage).to receive(:type).with(*urls)
        expect(FastImage).to receive(:size).with(*urls)

        subject.upload(urls)
      end
    end
  end
end
