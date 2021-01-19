require 'rails_helper'

describe 'Munchie API' do
  it 'returns the weather of the place where you will be eating' do
    user = {
      "email": 'whatever@example.com',
      "password": 'password',
      "password_confirmation": 'password'
    }
    post '/api/v1/users', params: user.to_json,
                          headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

    user = {
      "email": 'whatever@example.com',
      "password": 'password'
    }

    post '/api/v1/sessions', params: user.to_json,
                             headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

    user = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]

    json_response = File.read('spec/fixtures/travel.json')
    stub_request(:get, 'http://www.mapquestapi.com/directions/v2/route?from=Denver,CO&key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&to=Pueblo,CO')
      .to_return(status: 200, body: json_response, headers: {})

    trip = {
      "origin": 'Denver,CO',
      "destination": 'Pueblo,CO',
      "api_key": user[:api_key]
    }

    json_response = File.read('spec/fixtures/map_quest2.json')
    stub_request(:get, 'http://www.mapquestapi.com/geocoding/v1/address?key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&location=Pueblo,CO')
      .to_return(status: 200, body: json_response, headers: {})

    json_response2 = File.read('spec/fixtures/open_weather2.json')
    stub_request(:get, 'https://api.openweathermap.org/data/2.5/onecall?appid=88e6c754c08a30bee68f196402bd793a&exclude=minutely,alerts&lat=38.265425&lon=-104.610415&units=imperial')
      .to_return(status: 200, body: json_response2, headers: {})

    post '/api/v1/road_trip', params: trip.to_json,
                              headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

    json_response = File.read('spec/fixtures/food.json')
    stub_request(:get, 'https://api.yelp.com/v3/businesses/search?location=Pueblo,CO&open_now=true&term=chinese')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'Bearer UIdE7EkbP142pwgOjCirtfWoggDB_KpdbVTMCd-1COfbImfdAaLRHe9EdCfL12LqcfuAHTDo8ptn-TVc9xwvR7_fBg4RZREb-0bIq3iO391YdIsfXct9abzFPEYGYHYx',
          'User-Agent' => 'Faraday v1.3.0'
        }
      )
      .to_return(status: 200, body: json_response, headers: {})

    start = 'Denver,CO'
    end_spot = 'Pueblo,CO'
    type = 'chinese'
    get "/api/v1/munchies?start=#{start}&end=#{end_spot}&food=#{type}"

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json).to be_a Hash
    expect(json).to have_key :data
    expect(json[:data]).to have_key :id
    expect(json[:data][:id]).to eq(nil)
    expect(json[:data]).to have_key :attributes
    expected = %i[destination_city travel_time forecast restaurant]
    expect(json[:data][:attributes].keys).to eq(expected)
    expect(json[:data][:attributes][:destination_city]).to be_a String
    expect(json[:data][:attributes][:travel_time]).to be_a String
    expect(json[:data][:attributes][:forecast]).to be_a Hash
    expect(json[:data][:attributes][:restaurant]).to be_a Hash
  end
end
