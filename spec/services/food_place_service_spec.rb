require 'rails_helper'

describe 'FoodPlaceService' do
  it 'returns a food place data' do
    location = 'Pueblo,CO'
    term = 'chinese'

    json_response = File.read('spec/fixtures/food.json')
    stub_request(:get, 'https://api.yelp.com/v3/businesses/search?authorization=Bearer%20UIdE7EkbP142pwgOjCirtfWoggDB_KpdbVTMCd-1COfbImfdAaLRHe9EdCfL12LqcfuAHTDo8ptn-TVc9xwvR7_fBg4RZREb-0bIq3iO391YdIsfXct9abzFPEYGYHYx&location=Pueblo,CO&open_now=true&term=chinese')
      .to_return(status: 200, body: json_response, headers: {})

    place = FoodPlaceService.get_food_places(location, term)

    expect(place).to be_a Hash
    expect(place).to have_key :name
    expect(place[:name]).to be_a String
    expect(place).to have_key :location
    expect(place[:location]).to be_a Hash
    expect(place[:location]).to have_key :display_address
    expect(place[:location][:display_address].first).to be_a String
  end
end
