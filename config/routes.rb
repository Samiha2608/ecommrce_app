Rails.application.routes.draw do
resources :products do
  resources :comments, only: [ :create, :edit, :update, :destroy ]
   collection do
    get "category/:category", to: "products#category", as: "by_category"
  end
end



  # get "products/index"
  # get "products/show"
  # get "products/edit"
  # get "products/delete"
  # get "products/update"
  # get "products/destroy"
  # get "products/create"
  # get "users/index"
  # get "users/update"
  # get "users/show"
  # get "users/destroy"
  # get "users/edit"
  # devise_for :users
  get "home/index"
  devise_for :users, controllers: { registrations: "users/registrations" }
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
