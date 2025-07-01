Rails.application.routes.draw do
  get "carts/show"
resources :products do
  resources :comments, only: [ :create, :edit, :update, :destroy ]
  collection do
    get "category/:category", to: "products#category", as: "by_category"
  end
end
  get "home/index"
  devise_for :users, controllers: { registrations: "users/registrations" }
  root "home#index"
  get "/profile", to: "users#show", as: "user_profile"
  get "/cart", to: "cart#show"
  post "cart/add"
  post "cart/remove"



  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
