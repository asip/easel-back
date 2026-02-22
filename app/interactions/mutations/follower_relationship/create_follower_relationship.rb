# frozen_string_literal: true

# Mutations::FollowerRelationship::CreateFollowerRelationship class
class Mutations::FollowerRelationship::CreateFollowerRelationship
  include Mutation

  def initialize(user:, followee_id:)
    @user = user
    @followee_id = followee_id
  end

  def execute
    @user.follower_relationships.create(followee_id: @followee_id)
  end
end
