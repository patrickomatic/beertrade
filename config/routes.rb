Rails.application.routes.draw do
  resources :trades, except: [:destroy]
  resources :users, except: [:destroy, :create]

  get '/auth/:provider/callback', to: 'sessions#create'

  root to: 'sessions#new'
end
