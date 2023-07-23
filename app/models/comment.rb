# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  frame_id   :integer          not null
#  user_id    :integer          not null
#

# Comment
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :frame

  validates :body, presence: true, length: { maximum: 255 }
end
