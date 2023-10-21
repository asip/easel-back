# frozen_string_literal: true

# == Schema Information
#
# Table name: follow_relationships
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followee_id :integer
#  follower_id :integer
#
FactoryBot.define do
  factory :follow_relationship do
  end
end
