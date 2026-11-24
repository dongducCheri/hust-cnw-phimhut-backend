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
    
    #Movies & comments 
      resources :movies, only: [:index, :show] do 
        resources :comments, only: [:index, :create, :destroy], shallow: true 
      end
    
    #WatchLists 
      resources :watchlists, only: [:index, :create]

    get "episodes/:id/hls/master.m3u8", to: "hls#master"
    get "episodes/:id/hls/:quality/index.m3u8", to: "hls#variant"
    end
  end
end