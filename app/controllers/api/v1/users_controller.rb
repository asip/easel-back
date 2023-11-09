# frozen_string_literal: true

# api
module Api
  # v1
  module V1
    # Users Controller
    class UsersController < Api::V1::ApiController
      include ActionController::Cookies
      include Users::Query::PaginationQuery

      skip_before_action :authenticate, only: %i[create show frames]
      before_action :set_case

      def show
        user = @case.find_query(user_id: params[:id])
        render json: UserSerializer.new(user).serializable_hash
      end

      def frames
        pagination, frames = frames_query(user_id: query_params[:user_id], page: query_params[:page])

        render json: ListItem::FrameSerializer.new(frames, index_options).serializable_hash.merge(pagination)
      end

      def create
        success, user = @case.create_user(form_params:)
        if success
          render json: UserSerializer.new(user).serializable_hash
        else
          render json: { errors: user.errors.messages }.to_json
        end
      end

      def update
        success, user = @case.update_user(user: current_user, form_params:)
        if success
          cookies.permanent[:access_token] = user.token if user.saved_change_to_email
          render json: AccountSerializer.new(user).serializable_hash
        else
          render json: { errors: user.errors.messages }.to_json
        end
      end

      private

      def set_case
        @case = UsersCase.new
      end

      def index_options
        {}
      end

      def query_params
        params.permit(
          :page, :user_id
        )
      end

      def form_params
        params.require(:user).permit(
          :name, :email, :password, :password_confirmation, :image
        )
      end
    end
  end
end
