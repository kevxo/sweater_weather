require 'rails_helper'

describe 'Weather API' do
  it 'retrieves the weather of a city being searched' do
    location = 'denver,co'
    json_response = File.read('spec/fixtures/map_quest.json')
    stub_request(:get, 'http://www.mapquestapi.com/geocoding/v1/address?key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&location=denver,co')
      .to_return(status: 200, body: json_response, headers: {})

    json_response2 = File.read('spec/fixtures/open_weather.json')
    stub_request(:get, 'https://api.openweathermap.org/data/2.5/onecall?appid=88e6c754c08a30bee68f196402bd793a&exclude=minutely,alerts&lat=39.738453&lon=-104.984853&units=imperial')
      .to_return(status: 200, body: json_response2, headers: {})

    get "/api/v1/forcast?location=#{location}"

    expect(response).to be_successful
  end
end