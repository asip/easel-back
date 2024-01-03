# frozen_string_literal: true

# api
module Api
  # v1
  module V1
    # Users Controller
    class UsersController < Api::V1::ApiController
      include ActionController::Cookies
      include Queries::Users::Pagination

      skip_before_action :authenticate, only: %i[create show frames]

      def show
        user = Queries::Users::FindUser.run(user_id: params[:id])
        render json: UserSerializer.new(user).serializable_hash
      end

      def frames
        pagination, frames = list_frames_query(user_id: query_params[:user_id], page: query_params[:page])

        render json: ListItem::FrameSerializer.new(frames, index_options).serializable_hash.merge(pagination)
      end

      def create
        mutation = Mutations::Users::CreateUser.run(form_params:)
        user = mutation.user
        if mutation.success?
          render json: UserSerializer.new(user).serializable_hash
        else
          render json: { errors: user.errors.to_hash(true) }.to_json
        end
      end

      def update
        mutation = Mutations::Users::UpdateUser.run(user: current_user, form_params:)
        user = mutation.user
        if mutation.success?
          render json: AccountSerializer.new(user).serializable_hash
        else
          render json: { errors: user.errors.to_hash(true) }.to_json
        end
      end

      private

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
