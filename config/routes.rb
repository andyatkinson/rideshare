Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'

  namespace :api do
    resources :trip_requests, only: [:create, :index]
  end
end
