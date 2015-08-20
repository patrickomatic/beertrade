Rails.application.routes.draw do
  resources :users, except: [:destroy, :create]
  resources :trades, except: [:create]

  get '/auth/:provider/callback', to: 'sessions#create'

  root to: 'sessions#new'
end
