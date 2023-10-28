# frozen_string_literal: true

# Api
module Api
  # V1
  module V1
    # Frames Controller
    class FollowRelationshipsController < Api::V1::ApiController
      before_action :authenticate

      def following
        user = User.find(params[:user_id])
        following_ = @current_user.following?(user)
        render json: { following: following_ }
      end

      # follow
      def create
        current_user.follow(params[:user_id])
        head :no_content
      end

      # unfollow (フォロー外すとき)
      def destroy
        current_user.unfollow(params[:user_id])
        head :no_content
      end
    end
  end
end
