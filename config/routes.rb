Rails.application.routes.draw do
  root "tweets#index"

  resources :tweets, except: %i[new]
  resources :likes, only: %i[create destroy]
  get "/likes/:username", to: "likes#show"

  get "/login", to: "sessions#new"
  post "/sessions", to: "sessions#create"
  delete "/sessions", to: "sessions#destroy"

  get "/users/:username", to: "users#show", as: :user
  get "/profile", to: "users#edit", as: :edit_profile
  patch "/profile", to: "users#update"
  post "/signup", to: "users#create"
  get "/signup", to: "users#new"

  post "/auth/github", as: :github_login
  get "auth/github/callback", to: "sessions#create"

  namespace :api do # api/
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users, only: :create
    get "/profile", to: "users#show"
    patch "/profile", to: "users#update"

    resources :tweets, except: %i[new edit]
    get "/my_tweets", to: "my_tweets#index"

    resources :likes, except: %i[new edit update]
  end
end
