Rails.application.routes.draw do
  namespace :admin do
      resources :carts
      resources :comments
      resources :coupons
      resources :orders
      resources :order_products
      resources :products
      resources :roles
      resources :users

      root to: "carts#index"
    end
resources :products do
  resources :comments, only: [ :create, :edit, :update, :destroy ]
  collection do
    get "category/:category", to: "products#category", as: "by_category"
  end
end

post "products/:id/add_to_cart", to: "carts#add_to_cart", as: "add_to_cart_product"
get "cart", to: "carts#show", as: :cart

resource :cart, only: [ :show ] do
  patch "update_quantity/:id", to: "carts#update_quantity", as: :update_quantity
  delete "remove_item/:id", to: "carts#remove_item", as: "remove_item"
  post "apply_coupon", to: "carts#apply_coupon", as: :apply_coupon
end

resources :checkouts, only: [ :create ] do
  collection do
    get :success
    get :cancel
  end
end





  get "home/index"
  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions"
 }
  root "home#index"
  get "/profile", to: "users#show", as: "user_profile"




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
