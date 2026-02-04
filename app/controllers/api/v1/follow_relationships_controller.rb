# frozen_string_literal: true

# follow relationship api controller
class Api::V1::FollowRelationshipsController < Api::V1::ApiController
  def following
    user = Queries::User::FindUser.run(user_id: path_params[:user_id])
    following_ = current_user.following?(user)
    render json: { following: following_ }
  end

  # follow
  def create
    current_user.follow(path_params[:user_id])
    head :no_content
  end

  # unfollow (フォロー外すとき)
  def destroy
    current_user.unfollow(path_params[:user_id])
    head :no_content
  end

  private

  def path_params
    @path_params ||= params.permit(:user_id).to_h
  end
end
