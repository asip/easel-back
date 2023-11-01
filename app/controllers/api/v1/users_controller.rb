# frozen_string_literal: true

# api
module Api
  # v1
  module V1
    # Users Controller
    class UsersController < Api::V1::ApiController
      include ActionController::Cookies
      include Pagy::Backend
      include Pagination

      skip_before_action :authenticate, only: %i[create show frames]
      before_action :set_user, only: %i[show create update]
      before_action :set_query, only: %i[frames]

      def show
        render json: UserSerializer.new(@user).serializable_hash
      end

      def frames
        frames = User.find_by!(id: query_params[:user_id]).frames.order('frames.created_at': 'desc')
        pagy, frames = pagy(frames, { page: @page })
        pagination = resources_with_pagination(pagy)

        render json: ListItem::FrameSerializer.new(frames, index_options).serializable_hash.merge(pagination)
      end

      def create
        if @user.save(context: :with_validation)
          render json: UserSerializer.new(@user).serializable_hash
        else
          render json: { errors: @user.errors.messages }.to_json
        end
      end

      def update
        @user.attributes = user_params
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

      def index_options
        {}
      end

      def set_query
        @page = query_params[:page]
      end

      def query_params
        params.permit(
          :page,
          :user_id
        )
      end

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
