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
end
