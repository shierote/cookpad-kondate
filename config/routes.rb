Rails.application.routes.draw do
  root 'home#top'
  get 'home/index'
  post 'home/create'
  get 'home/:id', to: 'home#show'
  resources :orders
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
