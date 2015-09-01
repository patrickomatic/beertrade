Rails.application.routes.draw do
  resources :trades do
    resources :participants, only: [:create]
  end

  resources :users, except: [:destroy, :create]
  resources :sessions, only: [:create, :new, :destroy]

  get '/auth/:provider/callback', to: 'sessions#create'

  root to: 'sessions#new'
end
