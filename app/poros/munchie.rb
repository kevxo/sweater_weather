class Munchie
  attr_reader :destination_city, :travel_time, :forecast, :restaurant

  def initialize(trip, restaurant)
    @destination_city = trip.end_city
    @travel_time = trip.travel_time
    @forecast = trip.weather_at_eta
    @restaurant = format_restaurant(restaurant)
  end

  def format_restaurant(restaurant)
    {
      name: restaurant[:name],
      address: restaurant[:location][:display_address].first
    }
  end
end
