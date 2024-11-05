Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      get "/merchants/find", to: "merchants#find"
      get "/items/find_all", to: "items#find_all"
      get "/merchants/:id", to: "merchants#show"
      post "/merchants", to: "merchants#create"
      patch "/merchants/:id", to: "merchants#update"
      delete "/merchants/:id", to: "merchants#destroy"
    
      get "/merchants", to: "merchants#index"
      get "/merchants/:id", to: "merchants#show"
      post "/merchants", to: "merchants#create"
      patch "/merchants/:id", to: "merchants#update"
      delete "/merchants/:id", to: "merchants#destroy"
      
      get "/items/:id/merchant", to: "items_merchant#index"
      get "/merchants/:merchant_id/customers", to: "merchants_customers#index"
      get "/merchants/:merchant_id/invoices", to: "merchants_invoices#index"
      
      get '/items', to: "items#index"
      get '/items/:id', to: "items#show"
      get '/merchants/:id/items', to: "merchant_items#index"
      post "/items", to: "items#create"
      patch "/items/:id", to: "items#update"
      delete "/items/:id", to: "items#destroy"
    end 
  end
end


