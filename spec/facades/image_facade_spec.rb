require 'rails_helper'

describe ImageFacade do
  it 'returns a image object' do
    location = 'denver,co'
    json_response = File.read('spec/fixtures/image.json')
    stub_request(:get, 'https://api.pexels.com/v1/search?query=denver,co')
      .to_return(status: 200, body: json_response, headers: {})

    search = ImageFacade.get_image(location)
    expect(search).to be_a Image
    expect(search.image).to be_a Hash
    expected = %i[location image_url]
    expect(search.image.keys).to eq(expected)
    expect(search.credit).to be_a Hash
    expected = %i[source author logo]
    expect(search.credit.keys).to eq(expected)
  end
end