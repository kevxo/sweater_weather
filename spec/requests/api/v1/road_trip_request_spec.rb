require 'rails_helper'

describe 'Roadtrip Api' do
  it 'can create a roadtrip' do
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
    stub_request(:get, 'http://www.mapquestapi.com/directions/api/v2/routes?from=Denver,CO&key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&to=Pueblo,CO')
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

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json).to have_key :data
    expect(json[:data]).to be_a Hash
    expect(json[:data]).to have_key :id
    expect(json[:data][:id]).to eq(nil)
    expected = %i[start_city end_city travel_time weather_at_eta]
    expect(json[:data][:attributes].keys).to eq(expected)
    expect(json[:data][:attributes][:start_city]).to be_a String
    expect(json[:data][:attributes][:end_city]).to be_a String
    expect(json[:data][:attributes][:travel_time]).to be_a String
    expect(json[:data][:attributes][:weather_at_eta]).to be_a Hash
    expect(json[:data][:attributes][:weather_at_eta][:temperature]).to be_a Float
    expect(json[:data][:attributes][:weather_at_eta][:conditions]).to be_a String
  end

  it 'cannot create impossible trip' do
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

    json_response = File.read('spec/fixtures/impossibletravel.json')
    stub_request(:get, 'http://www.mapquestapi.com/directions/api/v2/routes?from=Denver,CO&key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&to=London,UK')
      .to_return(status: 200, body: json_response, headers: {})

    trip = {
      "origin": 'Denver,CO',
      "destination": 'London,UK',
      "api_key": user[:api_key]
    }

    json_response = File.read('spec/fixtures/map_london.json')
    stub_request(:get, 'http://www.mapquestapi.com/geocoding/v1/address?key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&location=London,UK')
      .to_return(status: 200, body: json_response, headers: {})

    json_response2 = File.read('spec/fixtures/london_weather.json')
    stub_request(:get, 'https://api.openweathermap.org/data/2.5/onecall?appid=88e6c754c08a30bee68f196402bd793a&exclude=minutely,alerts&lat=51.51333&lon=-0.08895&units=imperial')
      .to_return(status: 200, body: json_response2, headers: {})

    post '/api/v1/road_trip', params: trip.to_json,
                              headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)
    expect(json).to have_key :data
    expect(json[:data]).to be_a Hash
    expect(json[:data]).to have_key :id
    expect(json[:data][:id]).to eq(nil)
    expected = %i[start_city end_city travel_time weather_at_eta]
    expect(json[:data][:attributes].keys).to eq(expected)
    expect(json[:data][:attributes][:start_city]).to be_a String
    expect(json[:data][:attributes][:end_city]).to be_a String
    expect(json[:data][:attributes][:travel_time]).to eq('impossible route')
    expect(json[:data][:attributes][:weather_at_eta]).to be_a Hash
    expect(json[:data][:attributes][:weather_at_eta][:temperature]).to eq(nil)
    expect(json[:data][:attributes][:weather_at_eta][:conditions]).to eq(nil)
  end

  it 'gives incorrect api_key' do
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

    json_response = File.read('spec/fixtures/travel.json')
    stub_request(:get, 'http://www.mapquestapi.com/directions/api/v2/routes?from=Denver,CO&key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&to=Pueblo,CO')
      .to_return(status: 200, body: json_response, headers: {})

    trip = {
      "origin": 'Denver,CO',
      "destination": 'Pueblo,CO',
      "api_key": '"jgn983hy48thw9begh98h4539h4"'
    }

    post '/api/v1/road_trip', params: trip.to_json,
                              headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response).to_not be_successful
    expect(response.status).to eq(401)

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json).to have_key :error
    expect(json[:error]).to eq('Unauthorized')
  end
end
