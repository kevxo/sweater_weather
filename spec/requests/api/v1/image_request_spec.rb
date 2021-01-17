require 'rails_helper'

describe 'Image background API' do
  it 'retrieves the image of the city being searched' do
    location = 'denver,co'

    json_response = File.read('spec/fixtures/image.json')
    stub_request(:get, 'https://api.pexels.com/v1/search?query=denver,co')
      .to_return(status: 200, body: json_response, headers: {})

    get "/api/v1/backgrounds?location=#{location}"

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json).to be_a Hash
    expect(json[:data][:id]).to eq(nil)
    expect(json[:data]).to have_key :attributes

    image_data = json[:data][:attributes]

    expect(image_data).to have_key :image
    expect(image_data[:image]).to be_a Hash
    expect(image_data[:image][:location]).to be_a String
    expect(image_data[:image][:image_url]).to be_a String

    expect(image_data).to have_key :credit
    expect(image_data[:credit]).to be_a Hash
    expect(image_data[:credit][:source]).to be_a String
    expect(image_data[:credit][:author]).to be_a String
    expect(image_data[:credit][:logo]).to be_a String
  end
end
