Rails.application.routes.draw do
  root 'home#index'
  resources :addresses
  resources :categories, only: [:index, :new, :edit, :create, :update, :destroy]
  resources :coupons
  resources :orders
  resources :payments
  resources :products
  resources :stocks
  resources :users, only: [:index]
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get 'checkout/redirect_flow'
  get 'checkout/success'
  get 'checkout/failure'
  get 'checkout/pending'
  post 'checkout/address'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
