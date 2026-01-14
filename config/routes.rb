Rails.application.routes.draw do
  get "/terms",   to: "pages#terms"
  get "/privacy", to: "pages#privacy"

  devise_for :users, controllers: {
    passwords: "users/passwords",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :kids, only: [ :index, :new, :create, :show ] do
    member do
      get :select
    end

    resources :disease_records, only: [ :create ] do
      member do
        get :end_form
        patch :end_update
      end
    end

    resources :disease_records, only: [ :index ]

    resources :reported_symptoms, only: [ :new, :create ] do
      collection do
        post :start_record
        get :summary
      end
    end
  end

  # get "signup", to: "users#new"
  # ↓今後rootをpages/homeに変更予定
  root "pages#home"
  get "pages/home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
