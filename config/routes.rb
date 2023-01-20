Rails.application.routes.draw do
  resources :products, only: %i[create index update destroy show]
  resources :stores, only: %i[create index update destroy show]
  resources :brands, only: %i[create index update destroy show]
  resources :categories, only: %i[create index update destroy show]
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