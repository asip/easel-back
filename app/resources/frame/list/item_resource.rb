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

# Frame::List::ItemResource class
class Frame::List::ItemResource < ApplicationResource
  attributes :id, :user_id, :user_name, :name, :creator_name, :private

  attribute :tag_list do |frame|
    frame.tag_list.present? ? frame.tag_list.to_s&.split(",") : []
  end

  attribute :file_url do |frame|
    frame.file_proxy_url(:original)
  end

  attribute :file_two_url do |frame|
    frame.file_proxy_url(:two)
  end

  attribute :file_three_url do |frame|
    frame.file_proxy_url(:three)
  end

  attribute :file_six_url do |frame|
    frame.file_proxy_url(:six)
  end

  typelize id: :number, user_id: :number, user_name: :string,
           name: :string, creator_name: "string | null", private: :boolean
  typelize tag_list: "string | null"
  typelize file_url: :string, file_two_url: :string,
           file_three_url: :string, file_six_url: :string
end
