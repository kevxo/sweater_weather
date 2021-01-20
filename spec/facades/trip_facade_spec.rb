require 'rails_helper'

describe TripFacade do
  it 'returns a correct route RoadTrip object' do
    json_response = File.read('spec/fixtures/travel.json')
    stub_request(:get, 'http://www.mapquestapi.com/directions/v2/route?from=Denver,CO&key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&to=Pueblo,CO')
      .to_return(status: 200, body: json_response, headers: {})

    from = 'Denver,CO'
    to = 'Pueblo,CO'
    time = 6729

    json_response = File.read('spec/fixtures/map_quest2.json')
    stub_request(:get, 'http://www.mapquestapi.com/geocoding/v1/address?key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&location=Pueblo,CO')
      .to_return(status: 200, body: json_response, headers: {})

    json_response2 = File.read('spec/fixtures/open_weather2.json')
    stub_request(:get, 'https://api.openweathermap.org/data/2.5/onecall?appid=88e6c754c08a30bee68f196402bd793a&exclude=minutely,alerts&lat=38.265425&lon=-104.610415&units=imperial')
      .to_return(status: 200, body: json_response2, headers: {})

    response = File.read('spec/fixtures/open_weather2.json')
    data = JSON.parse(response, symbolize_names: true)
    forecast = Forcast.new(data)
    roadtrip = TripFacade.road_trip(from, to)

    expect(roadtrip).to be_a RoadTrip
    expect(roadtrip.start_city).to eq(from)
    expect(roadtrip.end_city).to eq(to)
    expect(roadtrip.travel_time).to eq('1 hour, 52 minutes')
    expect(roadtrip.weather_at_eta).to be_a Hash
    expect(roadtrip.get_weather(forecast, time)).to be_a Hash
    expected = %i[temperature conditions]
    expect(roadtrip.weather_at_eta.keys).to eq(expected)
    expect(roadtrip.weather_at_eta[:temperature]).to be_a Float
    expect(roadtrip.weather_at_eta[:conditions]).to be_a String
  end

  it 'returns a correct route RoadTrip object with less than 3600 time' do
    json_response = File.read('spec/fixtures/travel_boulder.json')
    stub_request(:get, 'http://www.mapquestapi.com/directions/v2/route?from=Denver,CO&key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&to=Boulder,CO')
      .to_return(status: 200, body: json_response, headers: {})

    from = 'Denver,CO'
    to = 'Boulder,CO'
    time = 2331

    json_response = File.read('spec/fixtures/map_quest3.json')
    stub_request(:get, 'http://www.mapquestapi.com/geocoding/v1/address?key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&location=Boulder,CO')
      .to_return(status: 200, body: json_response, headers: {})

    json_response2 = File.read('spec/fixtures/boulder_weather.json')
    stub_request(:get, 'https://api.openweathermap.org/data/2.5/onecall?appid=88e6c754c08a30bee68f196402bd793a&exclude=minutely,alerts&lat=40.015831&lon=-105.27927&units=imperial')
      .to_return(status: 200, body: json_response2, headers: {})

    response = File.read('spec/fixtures/open_weather2.json')
    data = JSON.parse(response, symbolize_names: true)
    forecast = Forcast.new(data)
    roadtrip = TripFacade.road_trip(from, to)

    expect(roadtrip).to be_a RoadTrip
    expect(roadtrip.start_city).to eq(from)
    expect(roadtrip.end_city).to eq(to)
    expect(roadtrip.travel_time).to eq('38 minutes')
    expect(roadtrip.weather_at_eta).to be_a Hash
    expect(roadtrip.get_weather(forecast, time)).to be_a Hash
    expected = %i[temperature conditions]
    expect(roadtrip.weather_at_eta.keys).to eq(expected)
    expect(roadtrip.weather_at_eta[:temperature]).to be_a Float
    expect(roadtrip.weather_at_eta[:conditions]).to be_a String
  end

  it 'returns a incorrect RoadTrip object' do
    json_response = File.read('spec/fixtures/impossibletravel.json')
    stub_request(:get, 'http://www.mapquestapi.com/directions/v2/route?from=Denver,CO&key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&to=London,UK')
      .to_return(status: 200, body: json_response, headers: {})

    from = 'Denver,CO'
    to = 'London,UK'

    json_response = File.read('spec/fixtures/map_london.json')
    stub_request(:get, 'http://www.mapquestapi.com/geocoding/v1/address?key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&location=London,UK')
      .to_return(status: 200, body: json_response, headers: {})

    json_response2 = File.read('spec/fixtures/london_weather.json')
    stub_request(:get, 'https://api.openweathermap.org/data/2.5/onecall?appid=88e6c754c08a30bee68f196402bd793a&exclude=minutely,alerts&lat=51.51333&lon=-0.08895&units=imperial')
      .to_return(status: 200, body: json_response2, headers: {})

    roadtrip = TripFacade.road_trip(from, to)

    expect(roadtrip.travel_time).to eq('impossible route')
    expected = {}
    expect(roadtrip.weather_at_eta).to eq(expected)
  end
end