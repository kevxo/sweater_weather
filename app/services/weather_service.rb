class WeatherService
  def self.forcast(lat, lon)
    response = conn.get('/data/2.5/onecall') do |req|
      req.params[:lat] = lat
      req.params[:lon] = lon
      req.params[:exclude] = 'minutely,alerts'
      req.params[:appid] = ENV['APPID']
      req.params[:units] = 'imperial'
    end

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: 'https://api.openweathermap.org')
  end
end
