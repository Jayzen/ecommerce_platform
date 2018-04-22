Rails.application.routes.draw do
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get  '/login',   to: 'sessions#new'
  post '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users do
    member do
      post :authorize, :unauthorize, :forbidden, :unforbidden
    end
  end
  root 'welcomes#index' 
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :password_alters,     only: [:edit, :update]
  resources :portraits,           only: [:new, :create, :update] 
  resources :categories
  resources :products do
    resources :product_images, only: [:index, :create, :destroy, :update]
  end
  resources :shopping_carts
  resources :orders
  resources :payments, only: [:index]
  resources :addresses do
    member do
      put :set_default_address
    end
  end 
end
