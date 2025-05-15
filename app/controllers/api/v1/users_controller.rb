# frozen_string_literal: true

# api
module Api
  # v1
  module V1
    # Users Controller
    class UsersController < Api::V1::ApiController
      include ActionController::Cookies
      include Queries::Users::Pagination

      skip_before_action :authenticate_user!, only: %i[show frames]

      def show
        user = Queries::Users::FindUser.run(user_id: params[:id])
        render json: UserResource.new(user).serializable_hash
      end

      def frames
        pagination, frames = list_frames_query(user_id: query_params[:user_id], page: query_params[:page])

        render json: JSON.parse(ListItem::FrameResource.new(frames).serialize).merge(pagination)
      end

      private

      def query_params
        params.permit(
          :page, :user_id
        )
      end
    end
  end
end
