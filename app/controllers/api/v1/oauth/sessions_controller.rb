# frozen_string_literal: true

# api
module Api
  # v1
  module V1
    # oauth
    module Oauth
      # Sessions Controller
      class SessionsController < Api::V1::ApiController
        include ActionController::Cookies

        skip_before_action :authenticate

        def create
          provider = auth_params[:provider]

          user = login_from_oauth(provider)
          # cookies.permanent[:access_token] = user.token
          render json: AccountSerializer.new(user).serializable_hash
        end

        private

        def login_from_oauth(provider)
          if (user = login_from(provider))
            user.assign_token(user_class.issue_token(id: user.id, email: user.email))
          else
            user = create_or_find_from(provider)
            user.assign_token(user_class.issue_token(id: user.id, email: user.email))
            reset_session
            auto_login(user)
          end
          user
        end

        def create_or_find_from(provider)
          if (user = user_class.find_by(email: @user_hash[:user_info]['email']))
            user.add_provider_to_user(provider, @user_hash[:uid].to_s)
          else
            user = create_from(provider)
          end
          user
        end

        def auth_params
          params.permit(:provider, :credential)
        end
      end
    end
  end
end
