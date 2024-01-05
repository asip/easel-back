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
        params_form = form_params
        user = login(params_form[:email], params_form[:password])
        if user
          create_successful(user:)
        else
          create_failed(form_params: params_form)
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
        render json: AccountSerializer.new(user).serializable_hash
      end

      private

      def login(email, password)
        token = login_and_issue_token(email, password)
        user = current_user
        user.assign_token(token) if user && (user.token.blank? || user.token_expire?)
        user
      end

      def create_successful(user:)
        render json: AccountSerializer.new(user).serializable_hash
      end

      def create_failed(form_params:)
        success, user = validate_login(form_params:)
        return if success

        render json: {
          messages: user.full_error_messages_on_login
        }
      end

      def validate_login(form_params:)
        user = User.find_by(email: form_params[:email])
        if user
          user.validate_password_on_login(form_params)
        else
          user = User.new(form_params)
          user.validate_email_on_login(form_params)
        end
        success = user.errors.empty?
        [ success, user ]
      end

      def form_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
