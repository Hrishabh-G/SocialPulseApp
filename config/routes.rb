Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/create'
  get 'password_resets/edit'
  get 'password_resets/update'
  # get 'sessions/new'
  # get 'sessions/create'
  # get 'sessions/destroy'

  root 'sessions#new'

  # get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  # delete '/logout', to: 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy', as: :logout

  get '/home', to: 'users#index', as: :home
  # root 'users#index'
  # get '/social-pulse.com', to: 'application#greeting_page'
  # root 'application#greeting_page'

  resources :users, only: [:new, :create]
  get '/users/verify_otp/:id', to: 'users#verify_otp', as: :verify_otp
  post '/users/validate_otp/:id', to: 'users#validate_otp', as: :validate_otp
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  resources :password_resets, only: [:new, :create, :edit, :update]
  get '/password_resets', to: redirect('/password_resets/new')
  get '/password_resets/:id/edit(.:format)', to: 'password_resets#edit'
end
