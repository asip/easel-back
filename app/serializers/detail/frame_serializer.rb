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
  # Frame Serializer
  class FrameSerializer < ListItem::FrameSerializer
    attributes :user_name

    attribute :tag_list do |object|
      object.tags_preview.join(',')
    end

    attribute :tags, &:tags_preview

    has_many :comments, serializer: CommentSerializer
  end
end
