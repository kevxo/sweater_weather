class RoadTrip
  attr_reader :start_city, :end_city, :travel_time, :weather_at_eta

  def initialize(start, finish, time, forecast)
    @start_city = start
    @end_city = finish
    @travel_time = convertime(time)
    @weather_at_eta = format_weather(forecast, time)
  end

  def convertime(time)
    if time.instance_of?(Integer)
      if time <= 3600
        min = time / 60 % 60
        "#{min} minutes"
      else
        hour = time / 3600
        min = time / 60 % 60
        "#{hour} hour, #{min} minutes"
      end
    else
      'impossible route'
    end
  end

  def get_weather(forecast, time)
    current_time = Time.at(forecast.current_weather[:datetime].to_i).strftime('%H:%M')
    estimated_time = "#{time / 3600}:#{time / 60 % 60}"
    destination_time = (current_time.gsub!(':', '').to_f / 100).round + (estimated_time.gsub!(':', '').to_f / 100).round
    weather = forecast.hourly_weather.find_all do |k|
      k[:time].to_i == destination_time
    end

    weather.first
  end

  def format_weather(forecast, time)
    if convertime(time) == 'impossible route'
      {}
    else
      weather = get_weather(forecast, time)
      {
        temperature: weather[:temperature],
        conditions: weather[:conditions]
      }
    end
  end
end
