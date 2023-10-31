# frozen_string_literal: true

# api
module Api
  # v1
  module V1
    # Frames Controller
    class FollowRelationshipsController < Api::V1::ApiController
      before_action :authenticate

      def following
        user = User.find(query_params[:user_id])
        following_ = @current_user.following?(user)
        render json: { following: following_ }
      end

      # follow
      def create
        current_user.follow(query_params[:user_id])
        head :no_content
      end

      # unfollow (フォロー外すとき)
      def destroy
        current_user.unfollow(query_params[:user_id])
        head :no_content
      end

      def query_params
        params.permit(:user_id)
      end
    end
  end
end
