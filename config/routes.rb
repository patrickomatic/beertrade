Rails.application.routes.draw do
  resources :trades, except: [:edit, :update] do
    resources :participants, only: [:create, :edit, :update]
  end

  resources :users, only: [:index, :show] do
    resources :participants, only: [:index]
  end

  resources :sessions, only: [:new, :destroy]

  resources :moderators, only: [:index]

  get '/auth/:provider/callback', to: 'sessions#create', as: :oauth_callback

  root to: 'sessions#new'
end
