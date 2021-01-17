require 'rails_helper'

describe Image do
  it 'exists' do
    location = 'denver,co'
    data = { id: 2_269_614,
             width: 4000,
             height: 6000,
             url: 'https://www.pexels.com/photo/traffic-lights-2269614/',
             photographer: 'Spencer Selover',
             photographer_url: 'https://www.pexels.com/@spencer-selover-142259',
             photographer_id: 142_259,
             avg_color: '#6D6E6B',
             src: { original: 'https://images.pexels.com/photos/2269614/pexels-photo-2269614.jpeg',
                    large2x: 'https://images.pexels.com/photos/2269614/pexels-photo-2269614.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                    large: 'https://images.pexels.com/photos/2269614/pexels-photo-2269614.jpeg?auto=compress&cs=tinysrgb&h=650&w=940',
                    medium: 'https://images.pexels.com/photos/2269614/pexels-photo-2269614.jpeg?auto=compress&cs=tinysrgb&h=350',
                    small: 'https://images.pexels.com/photos/2269614/pexels-photo-2269614.jpeg?auto=compress&cs=tinysrgb&h=130',
                    portrait: 'https://images.pexels.com/photos/2269614/pexels-photo-2269614.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800',
                    landscape: 'https://images.pexels.com/photos/2269614/pexels-photo-2269614.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200',
                    tiny: 'https://images.pexels.com/photos/2269614/pexels-photo-2269614.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280' },
             liked: false }
    image = Image.new(data, location)

    expect(image).to be_a Image
    expect(image.image).to be_a Hash
    expected = %i[location image_url]
    expect(image.image.keys).to eq(expected)
    expect(image.credit).to be_a Hash
    expected = %i[source author logo]
    expect(image.credit.keys).to eq(expected)
  end
end
