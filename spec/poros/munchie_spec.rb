require 'rails_helper'

describe Munchie do
  it 'exists' do
    start = 'Denver,CO'
    finish = 'Pueblo,CO'
    time = 6729

    response = File.read('spec/fixtures/open_weather2.json')
    data = JSON.parse(response, symbolize_names: true)
    forecast = Forcast.new(data)
    roadtrip = RoadTrip.new(start, finish, time, forecast)

    restaurant = { id: 'P1nNU18FWCEmkR0CfHSF7Q',
                   alias: 'black-swan-cafe-pueblo',
                   name: 'Black Swan Cafe',
                   image_url: 'https://s3-media3.fl.yelpcdn.com/bphoto/3_0MBKLUL76zltPUwntKIg/o.jpg',
                   is_closed: false,
                   url: 'https://www.yelp.com/biz/black-swan-cafe-pueblo?adjust_creative=9XvYA-uItZANHxhU95u7sA&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=9XvYA-uItZANHxhU95u7sA',
                   review_count: 11,
                   categories: [{ alias: 'cafes', title: 'Cafes' }, { alias: 'chinese', title: 'Chinese' },
                                { alias: 'chickenshop', title: 'Chicken Shop' }],
                   rating: 3.5,
                   coordinates: { latitude: 38.27369, longitude: -104.60915 },
                   transactions: ['delivery'],
                   price: '$',
                   location: { address1: '209 W 7th St', address2: '', address3: '', city: 'Pueblo', zip_code: '81003',
                               country: 'US', state: 'CO', display_address: ['209 W 7th St', 'Pueblo, CO 81003'] },
                   phone: '+17195420858',
                   display_phone: '(719) 542-0858',
                   distance: 3146.182318772612 }

    munchie = Munchie.new(roadtrip, restaurant)

    expect(munchie).to be_a Munchie
    expect(munchie.destination_city).to eq(finish)
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
