# frozen_string_literal: true

# rubocop: disable Metrics/BlockLength
Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "manager/sessions#new"

  namespace :manager do
    get "/" => "sessions#new", as: "login"
    resources :sessions, only: %i[new create destroy]
    get "/sessions" => "sessions#new"
  end
  delete "/logout" => "manager/sessions#destroy", as: "logout"

  namespace :api do
    namespace :v1 do
      namespace :oauth do
        resource :sessions, only: [ :create ]
      end
      resource :sessions, only: %i[create] do
        delete "/logout" => "/api/v1/sessions#destroy"
      end
      resources :users, only: %i[show create] do
        resource :follow_relationships, only: %i[create destroy]
        get "/frames" => "/api/v1/users#frames"
      end
      get "/profile" => "/api/v1/sessions#profile"
      put "/profile" => "/api/v1/users#update"
      delete "/profile" => "/api/v1/sessions#delete"
      get "/profile/following/:user_id" => "/api/v1/follow_relationships#following"
      resources :frames, only: %i[index show create update destroy] do
        get "/comments" => "/api/v1/frames#comments"
        resources :comments, only: %i[create]
      end
      resources :comments, only: [ :destroy ]
    end
  end
end
# rubocop: enable Metrics/BlockLength
