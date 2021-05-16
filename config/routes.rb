Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html  
  root "index#index"

  get "notes", to: "notes#index", as: :notes

  # get "products", to: "products#index"
  # get "products/listing", to: "products#listing"
  # get "products/:id", to: "products#show"
  get "products/generate", to: "products#generate_products", as: :generate_products
  get "products/page(/:page)", to: "products#index", as: :products_page
  resources :products  
  # get "/signup", to: "auth_users#new"
  # post "/signup", to: "auth_users#create"

  #
  # Auth Users Routes
  #
  # resources :auth_users, path: "/auth/users"
  # get "/auth/users", to: "auth_uses#index"
  # get "/auth/users/[:id]", to: "auth_users#show"
  # get "/auth/users/new", to: "auth_users#new"  
  # post "/auth/users", to: "auth_users#create"

  get 'auth/users', to: 'auth_users#index'
  get 'auth/users/new', to: 'auth_users#new', as: :new_auth_user
  post 'auth/users', to: 'auth_users#create'
  get 'auth/users/:id', to: 'auth_users#show', as: :auth_user
  patch 'auth/users/:id', to: 'auth_users#update'
  delete 'auth/users/:id', to: 'auth_users#destroy'

end
