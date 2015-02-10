Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "registrations", sessions: "sessions"}

  resources :images, only: [:index] do
    resources :favorites, only: [:create]
  end
end
