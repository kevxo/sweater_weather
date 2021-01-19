class MapQuestService
  def self.get_lon_lat(location)
    response = conn.get('/geocoding/v1/address') do |req|
      req.params[:key] = ENV['KEY']
      req.params[:location] = location
    end

    json = JSON.parse(response.body, symbolize_names: true)
    json[:results].last[:locations].last[:displayLatLng]
  end

  def self.get_estimated_time(from, to)
    response = conn.get('/directions/api/v2/routes') do |req|
      req.params[:key] = ENV['KEY']
      req.params[:from] = from
      req.params[:to] = to
    end

    json = JSON.parse(response.body, symbolize_names: true)
    if json[:route][:realTime]
      json[:route][:realTime]
    else
      json[:route]
    end
  end

  def self.conn
    Faraday.new(url: 'http://www.mapquestapi.com')
  end
end
