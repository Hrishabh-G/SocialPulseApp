Rails.application.routes.draw do
  # get 'sessions/new'
  # get 'sessions/create'
  # get 'sessions/destroy'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  # delete '/logout', to: 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy', as: :logout

  get '/home', to: 'users#index', as: :home
  # root 'users#index'
  # get '/social-pulse.com', to: 'application#greeting_page'
  root 'application#greeting_page'

  resources :users, only: [:new, :create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
