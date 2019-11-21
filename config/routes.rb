Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'

  namespace :api do
    resources :trips, only: [:index]
    resources :trip_requests, only: [:create]
  end

  mount Blazer::Engine, at: 'blazer'
end
