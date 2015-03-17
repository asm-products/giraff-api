Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "registrations", sessions: "sessions"}

  resources :images, only: [:index] do
    get :favorites, on: :collection
    resources :favorites, only: [:create]
    resources :passes, only: [:create]
  end

  resources :sessions, only: [:create, :destroy]

  post "/fbcreate", :to => "sessions#fbcreate"

  get "/404", :to => "errors#not_found"
  get "/500", :to => "errors#error"

  resources :images, only: [:index, :create]
  get "shortcode/:shortcode", to: 'images#shortcode'
end
