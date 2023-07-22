# frozen_string_literal: true

# rubocop: disable Metrics/BlockLength
Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'manager/sessions#new'

  namespace :manager do
    resources :sessions, only: %i[new create destroy]
    get 'login' => 'sessions#new', :as => 'login'
  end
  delete '/logout' => 'manager/sessions#destroy', as: 'logout'

  namespace :api do
    namespace :v1 do
      namespace :oauth do
        resource :sessions, only: [:create]
      end
      resource :sessions, only: %i[create] do
        delete '/logout' => '/api/v1/sessions#destroy'
      end
      resources :users, only: %i[show create] do
        resource :follow_relationships, only: %i[create destroy]
        get '/frames' => '/api/v1/users#frames'
      end
      get '/profile' => '/api/v1/sessions#profile'
      put '/profile' => '/api/v1/users#update'
      get '/profile/following/:user_id' => '/api/v1/follow_relationships#following'
      resources :frames, only: %i[index show create update destroy] do
        resources :comments, only: %i[index create]
      end
      resources :comments, only: [:destroy]
    end
  end
end
# rubocop: enable Metrics/BlockLength
