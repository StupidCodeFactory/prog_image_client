require 'spec_helper'

RSpec.describe ProgImage::FileUpload do
  let(:url) { 'https://picsum.photos/10/10/?random' }
  let(:fastimage) { double(FastImage, type: :jpeg, size: [10, 10], orientation: 1, content_length: 602) }

  let(:response_body) do
    '/9j/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wgARCAAKAAoDASIAAhEBAxEB/8QAFwAAAwEAAAAAAAAAAAAAAAAAAwQFB//EABQBAQAAAAAAAAAAAAAAAAAAAAL/2gAMAwEAAhADEAAAAW6WQDD/AP/EABoQAQACAwEAAAAAAAAAAAAAAAEABAIFERT/2gAIAQEAAQUCq7Onk+yrFSdZ/8QAFhEBAQEAAAAAAAAAAAAAAAAAAQBB/9oACAEDAQE/AQDL/8QAFxEAAwEAAAAAAAAAAAAAAAAAAAERUf/aAAgBAgEBPwGvT//EAB0QAAECBwAAAAAAAAAAAAAAAAABAwIREiExMnH/2gAIAQEABj8CpRtyfDSIsZP/xAAbEAACAgMBAAAAAAAAAAAAAAAAARFxIWGBkf/aAAgBAQABPyFOtyDkw9cJiTVG56f/2gAMAwEAAgADAAAAEMf/xAAVEQEBAAAAAAAAAAAAAAAAAAAAMf/aAAgBAwEBPxCkf//EABYRAQEBAAAAAAAAAAAAAAAAAAEAMf/aAAgBAgEBPxBXFf/EABwQAAMAAQUAAAAAAAAAAAAAAAABESExQZGh4f/aAAgBAQABPxBGXF0XKZayjDi3sWM2m6D9Uf/Z'
  end

  let(:faraday) { double(Faraday, get: double('response', body: response_body)) }
  subject { described_class.new(url) }

  before do
    expect(FastImage).to receive(:new).with(url).and_return(fastimage)
    expect(Base64).to receive(:urlsafe_encode64).and_return('encoded_image')
  end

  it 'serializes', vcr: { cassette_name: :picsum_10_10, record: :new_episodes } do
    subject.join
    expect(subject).to have_attributes(
                         type: :jpeg,
                         size: [10, 10],
                         orientation: 1,
                         content_length: 602,
                         data: 'data:image/jpeg;base64 encoded_image'
                       )
  end
end
