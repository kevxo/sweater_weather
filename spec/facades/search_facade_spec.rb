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
end