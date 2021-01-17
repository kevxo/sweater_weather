class Image
  attr_reader :image, :credit

  def initialize(data, location)
    @image = image_format(data, location)
    @credit = credit_format(data)
  end

  def image_format(data, location)
    {
      location: location,
      image_url: data[:url]
    }
  end

  def credit_format(data)
    {
      source: data[:src][:original],
      author: data[:photographer],
      logo: 'https://images.pexels.com/lib/api/pexels-white.png'
    }
  end
end
