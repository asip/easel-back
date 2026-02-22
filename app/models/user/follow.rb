# frozen_string_literal: true

# User::Follow module
module User::Follow
  extend ActiveSupport::Concern

  # (フォローしたときの処理)
  def follow(followee_id)
    Mutations::FollowerRelationship::CreateFollowerRelationship.run(user: self, followee_id:)
  end

  # (フォローを外すときの処理)
  def unfollow(followee_id)
    Mutations::FollowerRelationship::DeleteFollowerRelationship.run(user: self, followee_id:)
  end

  # (フォローしているか判定)
  def following?(followee)
    Validations::Following.run(user: self, followee:)
  end
end
