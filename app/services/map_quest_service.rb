class MapQuestService
  def self.get_lon_lat(location)
    response = conn.get('/geocoding/v1/address') do |req|
      req.params[:key] = ENV['KEY']
      req.params[:location] = location
    end

    json = JSON.parse(response.body, symbolize_names: true)
    json[:results].last[:locations].last[:displayLatLng]
  end

  def self.conn
    Faraday.new(url: 'http://www.mapquestapi.com')
  end
end
