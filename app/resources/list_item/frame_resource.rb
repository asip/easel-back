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
    attributes :id, :user_id, :user_name, :name, :comment, :private

    attribute :tag_list do |frame|
      frame.tags_display&.join(",")
    end

    attribute :tags, &:tags_display

    attribute :shooted_at do |frame|
      frame.shooted_at.present? ? I18n.l(frame.shooted_at, format: "%Y/%m/%d %H:%M") : ""
    end

    attribute :shooted_at_html do |frame|
      frame.shooted_at.present? ? I18n.l(frame.shooted_at) : ""
    end

    attribute :created_at do |frame|
      I18n.l(frame.created_at)
    end

    attribute :updated_at do |frame|
      I18n.l(frame.updated_at)
    end

    attribute :file_url, &:file_url

    attribute :file_two_url do |frame|
      frame.file_url(:two)
    end

    attribute :file_three_url do |frame|
      frame.file_url(:three)
    end
  end
end
