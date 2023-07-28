Rails.application.routes.draw do
  get 'likes/create'
  get 'likes/show'
  get 'likes/destroy'
  resources :tweets
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
