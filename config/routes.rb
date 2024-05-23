Rails.application.routes.draw do
  get 'car_models/index'
  get 'car_models/match'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root 'car_models#index'
  post 'match', to: 'car_models#match', as: 'match_car_models'

end
