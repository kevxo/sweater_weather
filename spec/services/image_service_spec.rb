require 'rails_helper'

describe ImageService do
  it 'returns image data' do
    location = 'denver,co'

    json_response = File.read('spec/fixtures/image.json')
    stub_request(:get, 'https://api.pexels.com/v1/search?query=denver,co')
      .to_return(status: 200, body: json_response, headers: {})

    service = ImageService.get_image(location)

    expect(service).to be_a Hash
    expect(service).to have_key :id
    expect(service[:id]).to be_a Integer

    expect(service).to have_key :width
    expect(service[:width]).to be_a Integer

    expect(service).to have_key :height
    expect(service[:height]).to be_a Integer

    expect(service).to have_key :url
    expect(service[:url]).to be_a String

    expect(service).to have_key :photographer
    expect(service[:photographer]).to be_a String

    expect(service).to have_key :photographer_id
    expect(service[:photographer_id]).to be_a Integer

    expect(service).to have_key :src
    expect(service[:src]).to be_a Hash
  end
end