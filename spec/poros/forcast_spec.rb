require 'rails_helper'

describe Forcast do
  it 'exists' do
    attrs = File.read('spec/fixtures/open_weather.json')
    data = JSON.parse(attrs, symbolize_names: true)
    forcast = Forcast.new(data)

    expect(forcast).to be_a Forcast
    expect(forcast.current(data[:current])).to be_a Hash
    expected = %i[datetime sunrise sunset temperature feels_like humidity uvi visibility conditions
                  icon]
    expect(forcast.current(data[:current]).keys).to eq(expected)
    expect(forcast.daily_weather(data[:daily])).to be_a Array
    expect(forcast.daily_weather(data[:daily]).count).to eq(5)
    expect(forcast.hourly(data[:hourly])).to be_a Array
    expect(forcast.hourly(data[:hourly]).count).to eq(8)
  end
end
