class Api::V1::TripController < ApplicationController
  def create
    user = User.find_by(api_key: params[:api_key])
    if user
      road_trip = TripFacade.road_trip(params[:origin], params[:destination])
      render json: RoadtripSerializer.new(road_trip)
    else
      render json: { error: 'Unauthorized' }, status: 401
    end
  end
end