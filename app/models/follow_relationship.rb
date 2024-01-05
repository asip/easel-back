# frozen_string_literal: true

# == Schema Information
#
# Table name: follow_relationships
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followee_id :bigint
#  follower_id :bigint
#

# Follow Relationship
class FollowRelationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"
end
