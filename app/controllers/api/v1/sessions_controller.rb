# frozen_string_literal: true

# api
module Api
  # v1
  module V1
    # Sessions Controller
    class SessionsController < Api::V1::ApiController
      include ActionController::Cookies

      skip_before_action :authenticate, only: %i[create]
      # before_action :set_csrf_token, only: [:show]

      # def show
      #   render json: {}, status: :ok
      # end

      def profile
        user = current_user

        render json: AccountSerializer.new(user).serializable_hash
      end

      #
      # sign in
      #
      def create
        params_user = user_params
        success, user = login(user_params: params_user)
        if success
          create_successful(user:)
        else
          create_failed(user_params: params_user)
        end
      end

      #
      # sign out
      #
      def destroy
        current_user&.reset_token
        user_id = current_user.id
        logout
        user = User.unscoped.find_by(id: user_id)
        cookies.delete(:access_token)
        render json: AccountSerializer.new(user).serializable_hash
      end

      #
      # delete login account
      #
      def delete
        current_user&.reset_token
        user_id = current_user.id
        logout
        user = User.unscoped.find_by(id: user_id)
        user.discard
        cookies.delete(:access_token)
        render json: AccountSerializer.new(user).serializable_hash
      end

      private

      def login(user_params:)
        token = login_and_issue_token(user_params[:email], user_params[:password])
        user = current_user
        if user
          user.assign_token(token) if user.token.blank? || user.token_expire?
          success = true
        else
          success = false
        end
        [success, user]
      end

      def create_successful(user:)
        cookies.permanent[:access_token] = user.token

        render json: AccountSerializer.new(user).serializable_hash
      end

      def create_failed(user_params:)
        success, user = validate_login(user_params:)
        return if success

        render json: {
          messages: user.errors.full_messages
        }
      end

      def validate_login(user_params:)
        user = User.find_by(email: user_params[:email])
        if user
          user.validate_password_on_login(user_params)
        else
          user = User.new(user_params)
          user.validate_email_on_login(user_params)
        end
        success = user.errors.empty?
        [success, user]
      end

      def user_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
