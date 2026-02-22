# frozen_string_literal: true

# Mutations::FollowerRelationship::DeleteFollowerRelationship class
class Mutations::FollowerRelationship::DeleteFollowerRelationship
  include Mutation

  def initialize(user:, followee_id:)
    @user = user
    @followee_id = followee_id
  end

  def execute
    @user.follower_relationships.find_by(followee_id: @followee_id)&.destroy
  end
end
