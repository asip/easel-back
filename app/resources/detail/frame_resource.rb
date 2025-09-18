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

# detail
module Detail
  # Frame Resource
  class FrameResource < ListItem::FrameResource
    attributes :comment

    attribute :shooted_at do |frame|
      frame.shooted_at.present? ? I18n.l(frame.shooted_at, format: "%Y/%m/%d %H:%M") : ""
    end

    attribute :created_at do |frame|
      I18n.l(frame.created_at, format: "%Y/%m/%d %H:%M")
    end

    attribute :updated_at do |frame|
      I18n.l(frame.updated_at, format: "%Y/%m/%d %H:%M")
    end

    many :comments, resource: CommentResource
  end
end
