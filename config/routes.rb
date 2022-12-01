Rails.application.routes.draw do

  resources :products, only: [:create, :index, :update, :destroy, :show]
  resources :stores, only: [:create, :index, :update, :destroy, :show]
  get 'products/index'
  get 'products/show'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # # Scraping test
  # resources :products do
  #   match '/scrape', to: 'products#scrape', via: :post, on: :collection
  # end

  # root to: 'products#index'
  # # Fin

end
