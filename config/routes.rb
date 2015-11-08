Rails.application.routes.draw do
  resources :trades, except: [:edit, :update] do
    resources :participants, only: [:create, :edit, :update]
  end

  resources :users, only: [:index, :show] do
    resources :participants, only: [:index]
  end

  resources :moderators, only: [:index]

  resources :sessions, only: [:new, :destroy]
  get '/auth/:provider/callback', to: 'sessions#create', as: :oauth_callback

  root to: 'trades#index'
end
