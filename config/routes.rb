Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  namespace :api do
    namespace :v1 do
      get "test", to: "test#index"

    # User Authentication
      post "signup", to: "registrations#create"
      post "login", to: "sessions#create"
      post "logout", to: "sessions#destroy"
      get "me", to: "sessions#me"

    #Genres
      resources :genres, only: [:index, :show]
    
    #Movies
      resources :movies, only: [:index, :show]
    
    #WatchLists 
      resources :watchlists, only: [:index, :create]
    end
  end
end