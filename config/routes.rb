Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  resources :styles
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :places, only: [:index, :show]
  resources :users do
    post 'change_activity', on: :member
  end
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'kaikki_bisset', to: 'beers#index'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  post 'places', to: 'places#search'
  get 'beerlist', to: 'beers#list'
  get 'brewerylist', to: 'breweries#list'
  # Defines the root path route ("/")
  root 'breweries#index'
end
