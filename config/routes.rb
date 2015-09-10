Rails.application.routes.draw do
  resources :trades, except: [:update] do
    resources :participants, only: [:create, :edit, :update]
  end

  resources :users, only: [:index, :show]
  resources :sessions, only: [:create, :new, :destroy]

  get '/auth/:provider/callback', to: 'sessions#create'

  root to: 'sessions#new'
end
