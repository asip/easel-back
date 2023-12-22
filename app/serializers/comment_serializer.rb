# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  frame_id   :bigint           not null
#  user_id    :bigint           not null
#

# Comment Serializer
class CommentSerializer
  include JSONAPI::Serializer
  set_type :comment
  set_id :id
  attributes :id, :user_id, :frame_id, :body

  attribute :user_name do |object|
    object.user.name
  end

  attribute :user_image_url do |object|
    object.user.image_url_for_view(:thumb)
  end

  attribute :updated_at do |object|
    I18n.l(object.updated_at)
  end

  attribute :error_messages do |object|
    object.errors.full_messages
  end
end
