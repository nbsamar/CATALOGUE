Rails.application.routes.draw do
  root 'products#index'
  resources :products
  resources :tags, only: [:show]
end
