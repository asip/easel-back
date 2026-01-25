# frozen_string_literal: true

# User::Follow module
module User::Follow
  extend ActiveSupport::Concern

  # (フォローしたときの処理)
  def follow(user_id)
    follower_relationships.create(followee_id: user_id)
  end

  # (フォローを外すときの処理)
  def unfollow(user_id)
    follower_relationships.find_by(followee_id: user_id)&.destroy
  end

  # (フォローしているか判定)
  def following?(user)
    followees.include?(user)
  end
end
