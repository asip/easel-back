# frozen_string_literal: true

# Api
module Api
  # V1
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
        @user = current_user

        render json: AccountSerializer.new(@user).serializable_hash
      end

      def create
        params_user = user_params
        token = login_and_issue_token(params_user[:email], params_user[:password])
        @user = current_user

        if @user
          @user.assign_token(token) if @user.token.blank? || @user.token_expire?
          cookies.permanent[:access_token] = token

          render json: AccountSerializer.new(@user).serializable_hash
        else
          validate_login(params_user)
        end
      end

      def destroy
        current_user&.reset_token
        cookies.delete(:access_token)
        user_id = current_user.id
        logout
        user = User.unscoped.find_by(id: user_id)
        render json: AccountSerializer.new(user).serializable_hash
      end

      def user_params
        params.require(:user).permit(:email, :password)
      end

      private

      def validate_login(params_user)
        @user = User.find_by(email: params_user[:email])
        if @user
          validate_password(params_user)
        else
          validate_email(params_user)
        end
        render json: {
          messages: @user.errors.full_messages
        }
      end

      def validate_password(params_user)
        @user.password = params_user[:password]
        return unless !@user.valid?(:login) && params_user[:password].present?

        @user.errors.add(:password, I18n.t('action.login.invalid'))
      end

      def validate_email(params_user)
        @user = User.new(params_user)
        @user.valid?(:login)
        @user.errors.add(:email, I18n.t('action.login.invalid')) if params_user[:email].present?
      end
    end
  end
end
