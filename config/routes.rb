# frozen_string_literal: true

# rubocop: disable Metrics/BlockLength
Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :admins, format: :html,
    controllers: {
      sessions: "admins/sessions"
    }
  devise_scope :admin do
    get "sign_in" => "admins/sessions#new"
    post "sign_in" => "admins/sessions#create"
  end

  mount RailsAdmin::Engine => "/", as: "rails_admin"

  devise_for :users, format: :json,
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      omniauth_callbacks: "users/omniauth_callbacks"
    }
  # ,
  # path_names: {
  #   sign_in: "login",
  #   sign_out: "logout",
  #   registration: "signup"
  # }
  devise_scope :user do
    post "/api/v1/sessions", to: "users/sessions#create"
    delete "/api/v1/sessions/logout", to: "users/sessions#destroy"
    post "/api/v1/users", to: "users/registrations#create"
    put "api/v1/account/profile", to: "users/registrations#update"
    delete "/api/v1/account", to: "users/registrations#destroy"
    get "/api/v1/users/:id", to: "api/v1/users#show"
    post "/api/v1/oauth/sessions", to: "users/omniauth_callbacks#google_oauth2"
  end

  # root ""

  put "/api/v1/account/password" => "account/passwords#update"

  namespace :api do
    namespace :v1 do
      resources :users, only: [] do
        resource :follow_relationships, only: %i[create destroy]
        get "/frames" => "/api/v1/users#frames"
      end
      get "/account/profile" => "/api/v1/sessions#profile"
      get "/account/frames" => "/api/v1/sessions#frames"
      get "/account/following/:user_id" => "/api/v1/follow_relationships#following"
      get "/frames/authenticated" => "/api/v1/frames#authenticated_index"
      resources :frames, only: %i[index show create update destroy] do
        get "/comments" => "/api/v1/frames#comments"
        get "/authenticated" => "/api/v1/frames#authenticated"
        resources :comments, only: %i[create update]
      end
      resources :comments, only: [ :destroy ]
    end
  end
end
# rubocop: enable Metrics/BlockLength
