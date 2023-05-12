# frozen_string_literal: true

# Api
module Api
  # V1
  module V1
    # Users Controller
    class UsersController < Api::V1::ApiController
      include ActionController::Cookies

      skip_before_action :authenticate, only: %i[create show]
      before_action :set_user, only: %i[show create update]

      def show
        render json: UserSerializer.new(@user).serializable_hash
      end

      def create
        @user.image_derivatives! if @user.image.present?
        if @user.save(context: :with_validation)
          render json: UserSerializer.new(@user).serializable_hash
        else
          render json: { errors: @user.errors.messages }.to_json
        end
      end

      def update
        @user.attributes = user_params
        @user.image_derivatives! if @user.image.present?
        # puts 'testtest'
        if @user.save(context: :with_validation)
          # puts @user.saved_change_to_email?
          update_token
          render json: AccountSerializer.new(@user).serializable_hash
        else
          render json: { errors: @user.errors.messages }.to_json
        end
      end

      private

      def update_token
        return unless @user.saved_change_to_email?

        @user.assign_token(user_class.issue_token(id: @user.id, email: @user.email))
        cookies.permanent[:access_token] = @user.token
      end

      def set_user
        @user = case action_name
                when 'show'
                  User.find_by!(id: params[:id])
                when 'new'
                  User.new
                when 'create'
                  User.new(user_params)
                else
                  current_user
                end
      end

      def user_params
        params.require(:user).permit(
          :name,
          :email,
          :password,
          :password_confirmation,
          :image
        )
      end
    end
  end
end
