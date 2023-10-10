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

# Detail
module Detail
  # Frame Serializer
  class FrameSerializer < ListItem::FrameSerializer
    attribute :updated_at do |object|
      I18n.l(object.updated_at)
    end

    attribute :tag_list do |object|
      object.tags_preview.join(',')
    end

    attribute :tags, &:tags_preview
  end
end
