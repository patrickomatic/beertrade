Rails.application.routes.draw do
  resources :trades, except: [:edit, :update] do
    collection do
      get :search
    end
    resources :participants, only: [:create, :edit, :update]
  end

  resources :users, only: [:index, :show, :create] do
    resources :participants, only: [:index]
  end

  resources :moderators, only: [:index]

  resources :help, only: [:index]

  resources :sessions, only: [:new, :destroy]
  get '/auth/:provider/callback', to: 'sessions#create', as: :oauth_callback

  root to: 'trades#index'
end
