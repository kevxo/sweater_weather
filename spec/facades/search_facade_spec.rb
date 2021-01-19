require 'rails_helper'

describe SearchFacade do
  it 'returns a forcast object' do
    location = 'denver,co'
    json_response = File.read('spec/fixtures/map_quest.json')
    stub_request(:get, 'http://www.mapquestapi.com/geocoding/v1/address?key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&location=denver,co')
      .to_return(status: 200, body: json_response, headers: {})

    json_response2 = File.read('spec/fixtures/open_weather.json')
    stub_request(:get, 'https://api.openweathermap.org/data/2.5/onecall?appid=88e6c754c08a30bee68f196402bd793a&exclude=minutely,alerts&lat=39.738453&lon=-104.984853&units=imperial')
      .to_return(status: 200, body: json_response2, headers: {})

    facade = SearchFacade.forcast(location)
    expect(facade).to be_a Forcast

    expect(facade.current_weather).to be_a Hash
    expected = %i[datetime sunrise sunset temperature feels_like humidity uvi visibility conditions
                  icon]
    expect(facade.current_weather.keys).to eq(expected)
    expect(facade.daily_weather).to be_a Array
    expect(facade.daily_weather.count).to eq(5)
    expect(facade.hourly_weather).to be_a Array
    expect(facade.hourly_weather.count).to eq(8)
  end

  it 'returns a image object' do
    location = 'denver,co'
    json_response = File.read('spec/fixtures/image.json')
    stub_request(:get, 'https://api.pexels.com/v1/search?query=denver,co')
      .to_return(status: 200, body: json_response, headers: {})

    search = SearchFacade.get_image(location)
    expect(search).to be_a Image
    expect(search.image).to be_a Hash
    expected = %i[location image_url]
    expect(search.image.keys).to eq(expected)
    expect(search.credit).to be_a Hash
    expected = %i[source author logo]
    expect(search.credit.keys).to eq(expected)
  end

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
    roadtrip = SearchFacade.road_trip(from, to)

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
    roadtrip = SearchFacade.road_trip(from, to)

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

    roadtrip = SearchFacade.road_trip(from, to)

    expect(roadtrip.travel_time).to eq('impossible route')
    expected = {}
    expect(roadtrip.weather_at_eta).to eq(expected)
  end

  it 'returns a Munchie Object' do
    start = 'Denver,CO'
    end_place = 'Pueblo,CO'
    food = 'chinese'

    json_response = File.read('spec/fixtures/travel.json')
    stub_request(:get, 'http://www.mapquestapi.com/directions/v2/route?from=Denver,CO&key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&to=Pueblo,CO')
      .to_return(status: 200, body: json_response, headers: {})

    json_response = File.read('spec/fixtures/map_quest2.json')
    stub_request(:get, 'http://www.mapquestapi.com/geocoding/v1/address?key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&location=Pueblo,CO')
      .to_return(status: 200, body: json_response, headers: {})

    json_response2 = File.read('spec/fixtures/open_weather2.json')
    stub_request(:get, 'https://api.openweathermap.org/data/2.5/onecall?appid=88e6c754c08a30bee68f196402bd793a&exclude=minutely,alerts&lat=38.265425&lon=-104.610415&units=imperial')
      .to_return(status: 200, body: json_response2, headers: {})

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

    munchie = SearchFacade.food_place_destination(start, end_place, food)

    expect(munchie).to be_a Munchie
    expect(munchie.destination_city).to eq(end_place)
    expect(munchie.travel_time).to eq('1 hour, 52 minutes')
    expect(munchie.forecast).to be_a Hash
    expected = %i[temperature conditions]
    expect(munchie.forecast.keys).to eq(expected)
    expect(munchie.restaurant).to be_a Hash
    expected = %i[name address]
    expect(munchie.restaurant.keys).to eq(expected)
    expect(munchie.restaurant[:name]).to be_a String
    expect(munchie.restaurant[:address]).to be_a String
  end
end
