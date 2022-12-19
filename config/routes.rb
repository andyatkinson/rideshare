Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'

  mount PgHero::Engine, at: "pghero"

  namespace :api do
    resources :trips, only: [:index, :show] do
      collection do
        get :my
      end
      member do
        get :details
      end
    end
    resources :trip_requests, only: [:create, :show]
  end

  post '/auth/login', to: 'authentication#login'

  mount Blazer::Engine, at: 'blazer'
end
