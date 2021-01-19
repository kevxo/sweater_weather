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

  def self.food_place_destination(start, end_place, food)
    trip = road_trip(start, end_place)
    restaurant = FoodPlaceService.get_food_places(end_place, food)
    Munchie.new(trip, restaurant)
  end
end
