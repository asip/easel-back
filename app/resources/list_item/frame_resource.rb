# frozen_string_literal: true

# == Schema Information
#
# Table name: frames
#
#  id         :bigint           not null, primary key
#  comment    :text
#  file_data  :text
#  name       :string           not null
#  shooted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

# list item
module ListItem
  # Frame Resource
  class FrameResource < BaseResource
    root_key :frame, :frames
    attributes :id, :user_id, :user_name, :name, :creator_name, :private

    attribute :tag_list do |frame|
      frame.joined_tags
    end

    attribute :tags, &:plain_tags

    attribute :file_url do |frame|
      frame.file_proxy_url(:original)
    end

    attribute :file_two_url do |frame|
      frame.file_proxy_url(:two)
    end

    attribute :file_three_url do |frame|
      frame.file_proxy_url(:three)
    end
  end
end
