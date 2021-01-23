require 'rails_helper'

describe WeatherService do
  it 'returns forcast data' do
    lat = '39.738453'
    lon = '-104.984853'
    json_response2 = File.read('spec/fixtures/open_weather.json')
    stub_request(:get, "https://api.openweathermap.org/data/2.5/onecall?appid=#{ENV['APPID']}&exclude=minutely,alerts&lat=39.738453&lon=-104.984853&units=imperial")
      .to_return(status: 200, body: json_response2, headers: {})

    search = WeatherService.forcast(lat, lon)
    expect(search).to be_a Hash
    expect(search).to have_key :current
    expect(search[:current]).to be_a Hash

    expect(search[:current]).to have_key :dt
    expect(search[:current][:dt]).to be_a Integer

    expect(search[:current]).to have_key :sunrise
    expect(search[:current][:sunrise]).to be_a Integer

    expect(search[:current]).to have_key :sunset
    expect(search[:current][:sunset]).to be_a Integer

    expect(search[:current]).to have_key :temp
    expect(search[:current][:temp]).to be_a Float

    expect(search[:current]).to have_key :feels_like
    expect(search[:current][:feels_like]).to be_a Float

    expect(search[:current]).to have_key :humidity
    expect(search[:current][:humidity]).to be_kind_of Numeric

    expect(search[:current]).to have_key :uvi
    expect(search[:current][:uvi]).to be_kind_of Numeric

    expect(search[:current]).to have_key :visibility
    expect(search[:current][:visibility]).to be_kind_of Numeric

    expect(search[:current][:weather].first).to have_key :description
    expect(search[:current][:weather].first[:description]).to be_a String

    expect(search[:current][:weather].first).to have_key :icon
    expect(search[:current][:weather].first[:icon]).to be_a String

    expect(search[:daily]).to be_a Array

    first_five_days = search[:daily].first(5)
    expect(first_five_days.count).to eq(5)

    expect(first_five_days.first).to have_key :dt
    expect(first_five_days.first[:dt]).to be_a Integer

    expect(first_five_days.first).to have_key :dt
    expect(first_five_days.first[:dt]).to be_a Integer

    expect(first_five_days.first).to have_key :sunrise
    expect(first_five_days.first[:sunrise]).to be_a Integer

    expect(first_five_days.first).to have_key :sunset
    expect(first_five_days.first[:sunset]).to be_a Integer

    expect(first_five_days.first[:temp]).to have_key :max
    expect(first_five_days.first[:temp][:max]).to be_a Float

    expect(first_five_days.first[:temp]).to have_key :min
    expect(first_five_days.first[:temp][:min]).to be_a Float

    expect(first_five_days.first[:weather].first).to have_key :description
    expect(first_five_days.first[:weather].first[:description]).to be_a String

    expect(first_five_days.first[:weather].first).to have_key :icon
    expect(first_five_days.first[:weather].first[:icon]).to be_a String

    expect(search[:hourly]).to be_a Array

    first_eight_hours = search[:hourly].first(8)

    expect(first_eight_hours.count).to eq(8)

    expect(first_eight_hours.first).to have_key :dt
    expect(first_eight_hours.first[:dt]).to be_a Integer

    expect(first_eight_hours.first).to have_key :temp
    expect(first_eight_hours.first[:temp]).to be_a Float

    expect(first_eight_hours.first).to have_key :wind_speed
    expect(first_eight_hours.first[:wind_speed]).to be_a Float

    expect(first_eight_hours.first).to have_key :dt
    expect(first_eight_hours.first[:dt]).to be_a Integer

    expect(first_eight_hours.first).to have_key :wind_deg
    expect(first_eight_hours.first[:wind_deg]).to be_a Integer

    expect(first_eight_hours.first[:weather].first).to have_key :description
    expect(first_eight_hours.first[:weather].first[:description]).to be_a String

    expect(first_eight_hours.first[:weather].first).to have_key :icon
    expect(first_eight_hours.first[:weather].first[:icon]).to be_a String
  end
end