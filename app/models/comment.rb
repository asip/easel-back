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

# Comment
class Comment < ApplicationRecord
  belongs_to :user, -> { with_discarded }
  belongs_to :frame

  validates :body, presence: true
end
