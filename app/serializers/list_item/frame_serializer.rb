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
  # Frame Serializer
  class FrameSerializer
    include JSONAPI::Serializer
    attributes :id, :user_id, :name, :comment, :private

    attribute :shooted_at do |object|
      object.shooted_at.present? ? I18n.l(object.shooted_at, format: "%Y/%m/%d %H:%M") : ""
    end

    attribute :shooted_at_html do |object|
      object.shooted_at.present? ? I18n.l(object.shooted_at) : ""
    end

    attribute :created_at do |object|
      I18n.l(object.created_at)
    end

    attribute :updated_at do |object|
      I18n.l(object.updated_at)
    end

    attribute :file_url, &:file_url

    attribute :file_two_url do |object|
      object.file_url(:two)
    end

    attribute :file_three_url do |object|
      object.file_url(:three)
    end
  end
end
