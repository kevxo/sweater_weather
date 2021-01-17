class Api::V1::WeatherController < ApplicationController
  def index
    SearchFacade.forcast(params[:location])
  end
end