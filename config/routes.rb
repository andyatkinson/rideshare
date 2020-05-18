Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'

  namespace :api do
    resources :trips, only: [:index, :show] do
      collection do
        get :my
      end
      member do
        get :details
      end
    end
    resources :trip_requests, only: [:create]
  end

  mount Blazer::Engine, at: 'blazer'
end
