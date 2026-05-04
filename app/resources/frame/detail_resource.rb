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

# Frame::DetailResource class
class Frame::DetailResource < Frame::List::ItemResource
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

  typelize comment: "string | null"
  typelize shooted_at: :string, created_at: :string, updated_at: :string
end
