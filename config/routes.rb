Rails.application.routes.draw do
  root "products#index"
  namespace :admin do
      resources :carts
      resources :coupons
      resources :orders
      resources :order_products
      resources :products
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

  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions" }
  get "/profile", to: "users#show", as: "user_profile"

  get "search/products", to: "search#products"
end
