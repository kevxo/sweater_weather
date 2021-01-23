require 'rails_helper'

describe 'Weather API' do
  it 'retrieves the weather of a city being searched' do
    location = 'denver,co'
    json_response = File.read('spec/fixtures/map_quest.json')
    stub_request(:get, "http://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['KEY']}&location=denver,co")
      .to_return(status: 200, body: json_response, headers: {})

    json_response2 = File.read('spec/fixtures/open_weather.json')
    stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['APPID']}&exclude=minutely,alerts&lat=39.738453&lon=-104.984853&units=imperial")
      .to_return(status: 200, body: json_response2, headers: {})

    get "/api/v1/forcast?location=#{location}"

    expect(response).to be_successful

    json = JSON.parse(response.body, symbolize_names: true)

    weather = json[:data][:attributes]

    expect(weather).to have_key :current_weather
    expect(weather[:current_weather]).to be_a Hash
    expected = %i[datetime sunrise sunset temperature feels_like humidity uvi visibility conditions
                  icon]
    expect(weather[:current_weather].keys).to eq(expected)
    expect(weather).to have_key :daily_weather
    expect(weather[:daily_weather]).to be_a Array
    expect(weather[:daily_weather].count).to eq(5)
    expect(weather).to have_key :hourly_weather
    expect(weather[:hourly_weather]).to be_a Array
    expect(weather[:hourly_weather].count).to eq(8)
  end
end
