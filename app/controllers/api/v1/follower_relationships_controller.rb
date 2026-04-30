# frozen_string_literal: true

# follower relationship api controller
class Api::V1::FollowerRelationshipsController < Api::V1::ApiController
  include FollowerRelationships::Variables

  def following
    render_following(following: current_user.following?(user))
  end

  # follow
  def create
    current_user.follow(user_id)
    head :no_content
  end

  # unfollow (フォロー外すとき)
  def destroy
    current_user.unfollow(user_id)
    head :no_content
  end

  private

  def user
    Queries::User::FindUser.run(user_id:)
  end

  def render_following(following:)
    render_resource({ following: })
  end
end
