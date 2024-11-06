Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
  # root "posts#index"
  
  get "/api/v1/items/find", to: "api/v1/items#find"
  get "/api/v1/merchants/find", to: "api/v1/merchants#find"
  get "/api/v1/items/find_all", to: "api/v1/items#find_all"
  get '/api/v1/merchants/find_all', to: 'api/v1/merchants#find_all'




  namespace :api do
    namespace :v1 do
      get "/merchants/find", to: "merchants#find"
      get "/items/find_all", to: "items#find_all"

      resources :merchants
      resources :items
      
      get '/merchants/:id/items', to: "merchant_items#index"
      get "/items/:id/merchant", to: "items_merchant#index"

      get "/merchants/:merchant_id/customers", to: "merchants_customers#index"
      get "/merchants/:merchant_id/invoices", to: "merchants_invoices#index"
      
    end 
  end
end


