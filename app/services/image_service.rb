class ImageService
  def self.get_image(location)
    response = conn.get('/v1/search') do |req|
      req.params[:query] = location
    end

    json = JSON.parse(response.body, symbolize_names: true)
    json[:photos].sample
  end

  def self.conn
    Faraday.new(url: 'https://api.pexels.com') do |f|
      f.headers[:Authorization] = ENV['APIKEY']
    end
  end
end