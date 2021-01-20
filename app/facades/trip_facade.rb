class TripFacade
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