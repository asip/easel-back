# frozen_string_literal: true

# Api
module Api
  # V1
  module V1
    module Oauth
      # Oauth Sessions Controller
      class SessionsController < Api::V1::ApiController
        include ActionController::Cookies
        include Sorcery::Credential

        skip_before_action :authenticate

        def create
          provider = auth_params[:provider]

          login_from_oauth(provider)
          cookies.permanent[:access_token] = @user.token
          render json: AccountSerializer.new(@user).serializable_hash
        end

        private

        def login_from_oauth(provider)
          if (@user = login_from(provider))
            @user.assign_token(user_class.issue_token(id: @user.id, email: @user.email))
          else
            @user = create_from(provider)
            reset_session
            @user.assign_token(user_class.issue_token(id: @user.id, email: @user.email))
            auto_login(@user)
          end
        end

        def auth_params
          params.permit(:provider, :credential)
        end
      end
    end
  end
end
