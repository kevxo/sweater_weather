class FoodPlaceService
  def self.get_food_places(location, term)
    response = conn.get('/v3/businesses/search') do |req|
      req.params[:location] = location
      req.params[:term] = term
      req.params[:open_now] = 'true'
    end

    json = JSON.parse(response.body, symbolize_names: true)
    json[:businesses].sample
  end

  def self.conn
    Faraday.new(url: 'https://api.yelp.com') do |req|
      req.params[:authorization] = ENV['YELPKEY']
    end
  end
end