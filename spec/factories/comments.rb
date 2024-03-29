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
FactoryBot.define do
  factory :comment do
    body { 'test test' }
  end
end
