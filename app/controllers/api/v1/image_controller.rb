class Api::V1::ImageController < ApplicationController
  def index
    image = ImageFacade.get_image(params[:location])
    render json: ImageSerializer.new(image)
  end
end