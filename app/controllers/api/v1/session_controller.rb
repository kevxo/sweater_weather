class Api::V1::SessionController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      render json: UserSerializer.new(user), status: 200
    else
      render json: { error: 'credentials are incorrect' }, status: 400
    end
  end
end
