require 'date'
class Forcast
  def initialize(data)
    @current = current(data[:current])
    @daily_weather = daily_weather(data[:daily])
    @hourly = hourly(data[:hourly])
  end

  def current(data)
    {
      datetime: Time.at(data[:dt]),
      sunrise: Time.at(data[:sunrise]),
      sunset: Time.at(data[:sunset]),
      temperature: data[:temp],
      feels_like: data[:feels_like],
      humidity: data[:humidity],
      uvi: data[:uvi],
      visibility: data[:visibility],
      conditions: data[:weather].first[:description],
      icon: data[:weather].first[:icon]
    }
  end

  def daily_weather(data)
    data.first(5).map do |attr|
      {
        date: Time.at(attr[:dt]).strftime('%F'),
        sunrise: Time.at(attr[:sunrise]),
        sunset: Time.at(attr[:sunset]),
        max_temp: attr[:temp][:max],
        min_temp: attr[:temp][:min],
        conditions: attr[:weather].first[:description],
        icon: attr[:weather].first[:icon]
      }
    end
  end

  def deg_to_compass(num)
    val = ((num / 22.5) + 0.5)
    arr = %w[N NNE NE ENE E ESE SE SSE S SSW SW WSW W WNW NW NNW]
    arr[(val % 16)]
  end

  def hourly(data)
    data.first(8).map do |attr|
      {
        time: Time.at(attr[:dt]).strftime('%H-%M-%S'),
        temperature: attr[:temp],
        wind_speed: attr[:wind_speed],
        wind_direction: deg_to_compass(attr[:wind_deg]),
        conditions: attr[:weather].first[:description],
        icon: attr[:weather].first[:icon]
      }
    end
  end
end
