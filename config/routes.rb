Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get '/forcast', to: 'weather#index'
      get '/backgrounds', to: 'image#index'
      get 'munchies', to: 'munchie#index'

      post '/users', to: 'user#create'
      post '/sessions', to: 'session#create'
      post '/road_trip', to: 'trip#create'
    end
  end
end
