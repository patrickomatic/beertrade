Rails.application.routes.draw do
  resources :trades, except: [:edit, :update] do
    resources :participants, only: [:create, :edit, :update]
  end

  resources :users, only: [:index, :show, :create] do
    resources :participants, only: [:index]
  end

  resources :moderators, only: [:index] 
  get 'moderators/import_trades', to: "moderators#import_trades"
  get 'moderators/change_username', to: "moderators#change_username"
  get 'moderators/add_trade', to: "moderators#add_trade"

  resources :help, only: [:index]

  resources :sessions, only: [:new, :destroy]
  get '/auth/:provider/callback', to: 'sessions#create', as: :oauth_callback

  root to: 'trades#index'
end
