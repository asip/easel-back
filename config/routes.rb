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
    get "admins/sign_out" => "admins/sessions#destroy"
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
    post "/api/v1/oauth/sessions", to: "users/omniauth_callbacks#google"
  end

  # root ""

  namespace :api do
    namespace :v1 do
      resources :users, only: [] do
        resource :follower_relationships, only: %i[create destroy]
        member do
          get :frames
        end
      end

      scope :account do
        get "/profile" => "sessions#profile"
        get "/frames" => "sessions#frames"
        get "/following/:user_id" => "follower_relationships#following"
        put "/password" => "account/passwords#update"
      end

      resources :frames, only: %i[index show create update destroy] do
        get "/comments" => "frames#comments"
        get "/authenticated" => "frames#authenticated"
        resources :comments, only: %i[create update destroy]
        collection do
          get "/authenticated" => "frames#authenticated_index"
        end
      end

      resources :tags, only: [] do
        collection do
          get :search
        end
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
