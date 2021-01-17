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
end
