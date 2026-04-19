# frozen_string_literal: true

# User::Follow module
module User::Follow
  extend ActiveSupport::Concern

  # Processing when followed
  # (フォローしたときの処理)
  def follow(followee_id)
    Mutations::FollowerRelationship::CreateFollowerRelationship.run(user: self, followee_id:)
  end

  # The process of unfollowing someone
  # (フォローを外すときの処理)
  def unfollow(followee_id)
    Mutations::FollowerRelationship::DeleteFollowerRelationship.run(user: self, followee_id:)
  end

  # Check if following
  # (フォローしているか判定)
  def following?(followee)
    Validations::Following.run(user: self, followee:)
  end
end
