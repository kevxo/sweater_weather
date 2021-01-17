require 'rails_helper'

describe Forcast do
  it 'exists' do
    attrs = File.read('spec/fixtures/open_weather.json')
    data = JSON.parse(attrs, symbolize_names: true)
    forcast = Forcast.new(data)

    expect(forcast).to be_a Forcast
    expect(forcast.current_weather).to be_a Hash
    expected = %i[datetime sunrise sunset temperature feels_like humidity uvi visibility conditions
                  icon]
    expect(forcast.current_weather.keys).to eq(expected)
    expect(forcast.daily_weather).to be_a Array
    expect(forcast.daily_weather.count).to eq(5)
    expect(forcast.hourly_weather).to be_a Array
    expect(forcast.hourly_weather.count).to eq(8)
  end
end
