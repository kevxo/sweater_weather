class WeatherFacade
  def self.forcast(location)
    json = MapQuestService.get_lon_lat(location)
    lat = json[:lat]
    lon = json[:lng]

    json = WeatherService.forcast(lat, lon)
    Forcast.new(json)
  end
end
