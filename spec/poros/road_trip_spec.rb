require 'rails_helper'

describe RoadTrip do
  it 'exists' do
    start = 'Denver,CO'
    finish = 'Pueblo,CO'
    time = 6729

    response = File.read('spec/fixtures/open_weather2.json')
    data = JSON.parse(response, symbolize_names: true)
    forecast = Forcast.new(data)
    roadtrip = RoadTrip.new(start, finish, time, forecast)

    expect(roadtrip).to be_a RoadTrip
    expect(roadtrip.start_city).to eq(start)
    expect(roadtrip.end_city).to eq(finish)
    expect(roadtrip.travel_time).to eq('1 hour, 52 minutes')
    expect(roadtrip.weather_at_eta).to be_a Hash
    expect(roadtrip.get_weather(forecast, time)).to be_a Hash
    expected = %i[temperature conditions]
    expect(roadtrip.weather_at_eta.keys).to eq(expected)
    expect(roadtrip.weather_at_eta[:temperature]).to be_a Float
    expect(roadtrip.weather_at_eta[:conditions]).to be_a String
  end

  it 'has less time than 3600' do
    start = 'Denver,CO'
    finish = 'Pueblo,CO'
    time = 1222

    response = File.read('spec/fixtures/open_weather2.json')
    data = JSON.parse(response, symbolize_names: true)
    forecast = Forcast.new(data)
    roadtrip = RoadTrip.new(start, finish, time, forecast)

    expect(roadtrip.travel_time).to eq('20 minutes')
  end

  it 'is an impossible route' do
    start = 'Denver,CO'
    finish = 'London,UK'
    time = {route: {error: 'impossible'}}

    response = File.read('spec/fixtures/london_weather.json')
    data = JSON.parse(response, symbolize_names: true)
    forecast = Forcast.new(data)
    roadtrip = RoadTrip.new(start, finish, time, forecast)

    expect(roadtrip.travel_time).to eq('impossible route')
    expected = {}
    expect(roadtrip.weather_at_eta).to eq(expected)
  end
end