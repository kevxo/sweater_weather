require 'rails_helper'

describe MapQuestService do
  it 'return lon and lat data' do
    json_response = File.read('spec/fixtures/map_quest.json')
    stub_request(:get, 'http://www.mapquestapi.com/geocoding/v1/address?key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&location=denver,co')
      .to_return(status: 200, body: json_response, headers: {})

    search = MapQuestService.get_lon_lat('denver,co')
    expect(search).to be_a Hash

    expect(search).to have_key :lat
    expect(search[:lat]).to be_a Float

    expect(search).to have_key :lng
    expect(search[:lng]).to be_a Float
  end

  it 'returns estimated time if route is correct' do
    from = 'Denver,CO'
    to = 'Pueblo,CO'
    json_response = File.read('spec/fixtures/travel.json')
    stub_request(:get, "http://www.mapquestapi.com/directions/api/v2/routes?from=Denver,CO&key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&to=Pueblo,CO")
      .to_return(status: 200, body: json_response, headers: {})

    search = MapQuestService.get_estimated_time(from, to)
    expect(search).to be_a Integer
  end

  it 'returns route error hash instead of time' do
    from = 'Denver,CO'
    to = 'London,UK'
    json_response = File.read('spec/fixtures/impossibletravel.json')
    stub_request(:get, "http://www.mapquestapi.com/directions/api/v2/routes?from=Denver,CO&key=Wizb13EM9er7D6EtOktCFlEJSYC2w1c5&to=London,UK")
      .to_return(status: 200, body: json_response, headers: {})

    search = MapQuestService.get_estimated_time(from, to)
    expect(search).to be_a Hash
    expect(search).to have_key :routeError
    expect(search[:routeError]).to be_a Hash
  end
end
