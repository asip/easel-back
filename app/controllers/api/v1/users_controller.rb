# frozen_string_literal: true

# Api
module Api
  # V1
  module V1
    # Users Controller
    class UsersController < Api::V1::ApiController
      skip_before_action :authenticate, only: %i[create show]
      before_action :set_user, only: %i[show create edit update]

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
        if @user.save(context: :with_validation)
          render json: UserSerializer.new(@user).serializable_hash
        else
          render json: { errors: @user.errors.messages }.to_json
        end
      end

      private

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
