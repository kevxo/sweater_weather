class Api::V1::WeatherController < ApplicationController
  def index
    forcast = WeatherFacade.forcast(params[:location])
    render json: ForecastSerializer.new(forcast)
  end
end