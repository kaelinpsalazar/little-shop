Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  get "/api/v1/merchants/:id", to: 'api/v1/merchants#show'
  # Defines the root path route ("/")
  # root "posts#index"

  get "/api/v1/items/:id/merchant", to: 'api/v1/items_merchant#index'
  get "/api/v1/merchants/:merchant_id/customers", to: 'api/v1/merchants_customers#index'
  
  get '/api/v1/items', to: 'api/v1/items#index'
  get '/api/v1/items/:id', to: 'api/v1/items#show'
  post "/api/v1/items", to: "api/v1/items#create"
  patch "/api/v1/items/:id", to: "api/v1/items#update"
  delete "api/v1/items/:id", to: "api/v1/items#destroy"
end