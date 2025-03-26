Rails.application.routes.draw do
  # Remove these duplicate lines
  # devise_for :admin_users, ActiveAdmin::Devise.config  <- DUPLICATE
  # ActiveAdmin.routes(self)  <- DUPLICATE

  # Keep only one set of ActiveAdmin routes
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  devise_for :users
  
  # Your other routes remain the same
  get "up" => "rails/health#show", as: :rails_health_check

  get '/about', to: 'pages#about'
  get '/contact', to: 'pages#contact'
  get '/faq', to: 'pages#faq'

  resources :products, only: [:index, :show] do
    collection do
      get 'category/:id', to: 'products#category', as: 'category'
      get 'search', to: 'products#search', as: 'search'
    end
  end
  post 'checkout', to: 'orders#create', as: 'checkout'
  
  resource :cart, only: [:show, :update, :destroy] do
    member do
      post 'add_item'
      post 'remove_item'
      post 'update_quantity'
    end
  end
  
  resources :orders, only: [:index, :show, :create] do
    collection do
      get 'checkout'
      post 'process_payment'
      get 'confirmation'
    end
  end
  
  resource :profile, only: [:show, :edit, :update] do
    resources :addresses, except: [:show, :index]
  end
  
  root to: 'home#index'
end