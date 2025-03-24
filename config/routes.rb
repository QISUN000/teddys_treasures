Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  get '/about', to: 'pages#about'
  get '/contact', to: 'pages#contact'
  get '/faq', to: 'pages#faq'

  resources :products, only: [:index, :show] do
    collection do
      get 'category/:id', to: 'products#category', as: 'category'
      get 'search', to: 'products#search', as: 'search'
    end
  end
  
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
