class Api::V1::WeatherController < ApplicationController
  def index
    forcast = SearchFacade.forcast(params[:location])
    render json: ForecastSerializer.new(forcast)
  end
end