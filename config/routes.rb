Rails.application.routes.draw do
  if Rails.env.development? || Rails.env.test?
    get '/simulator', to: 'simulator#index'
    get '/simulator/trips/:id/positions', to: 'simulator#positions'
    get '/simulator/snapshot', to: 'simulator#snapshot'
  end

  mount PgHero::Engine, at: 'pghero'

  namespace :api do
    resources :trips, only: %i[index show] do
      collection do
        get :my
      end
      member do
        get :details
      end
    end
    resources :trip_requests, only: %i[create show]
  end

  post '/auth/login', to: 'authentication#login'
end
