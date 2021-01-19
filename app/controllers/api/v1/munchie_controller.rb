class Api::V1::MunchieController < ApplicationController
  def index
    food_place = SearchFacade.food_place_destination(params[:start], params[:end], params[:food])
  end
end