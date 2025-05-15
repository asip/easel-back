# frozen_string_literal: true

# api
module Api
  # v1
  module V1
    # Sessions Controller
    class SessionsController < Api::V1::ApiController
      include ActionController::Cookies
      include Queries::Sessions::Pagination

      # def show
      #   render json: {}, status: :ok
      # end

      def profile
        user = current_user

        # response.set_header("Authorization", "Bearer #{user.token}")
        render json: AccountResource.new(user).serializable_hash
      end

      def frame
        frame = Queries::Frames::FindFrameWithRelations.run(frame_id: params[:id], user: current_user)

        render json: Detail::FrameResource.new(frame).serializable_hash
      end

      def frames
        pagination, frames = list_frames_query(user: current_user, page: query_params[:page])

        render json: JSON.parse(ListItem::FrameResource.new(frames).serialize).merge(pagination)
      end

      private

      def query_params
        params.permit(
          :page
        )
      end
    end
  end
end
