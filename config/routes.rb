Rails.application.routes.draw do
  get "/terms",   to: "pages#terms"
  get "/privacy", to: "pages#privacy"

  devise_for :users, controllers: {
    passwords: "users/passwords",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :kids, only: [ :index, :new, :create, :show, :edit, :update, :destroy ] do
    member do
      get :select
    end

    resources :disease_records, only: [:index, :create, :edit, :update ] do
      member do
        get :end_form
        patch :end_update
      end
    end

    resources :reported_symptoms, only: [ :new, :create, :edit, :update, :destroy] do
      collection do
        post :start_record
        get :summary
        get :daily_edit
      end
    end
  end

  root "pages#home"
  get "pages/home"

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

end
