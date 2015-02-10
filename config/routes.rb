Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "registrations", sessions: "sessions"}

  resources :images, only: [:index] do
    resources :favorites, only: [:create]
    resources :passes, only: [:create]
  end

  get "/404", :to => "errors#not_found"
  get "/500", :to => "errors#error"
end
