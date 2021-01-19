class SearchFacade
  def self.forcast(location)
    json = MapQuestService.get_lon_lat(location)
    lat = json[:lat]
    lon = json[:lng]

    json = WeatherService.forcast(lat, lon)
    Forcast.new(json)
  end

  def self.get_image(location)
    data = ImageService.get_image(location)
    Image.new(data, location)
  end

  def self.road_trip(from, to)
    real_time = MapQuestService.get_estimated_time(from, to)
    lon_lat = MapQuestService.get_lon_lat(to)
    lat = lon_lat[:lat]
    lon = lon_lat[:lng]

    forcast = WeatherService.forcast(lat, lon)
    weather = Forcast.new(forcast)
    RoadTrip.new(from, to, real_time, weather)
  end
end
