Rails.application.routes.draw do

  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end if Rails.env.production?
  mount Sidekiq::Web => '/admin/sidekiq'

  devise_for :users, controllers: {registrations: "registrations", sessions: "sessions"}

  resources :images, only: [:index, :create] do
    get :favorites, on: :collection
    resources :favorites, only: [:create]
    resources :passes, only: [:create]
  end

  resources :sessions, only: [:create, :destroy]

  post "/fbcreate", :to => "sessions#fbcreate"
  post "/create_anonymous", :to => "sessions#create_anonymous"

  get "/404", :to => "errors#not_found"
  get "/500", :to => "errors#error"

  get "shortcode/:shortcode", to: 'images#shortcode'
end
