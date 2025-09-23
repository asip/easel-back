# frozen_string_literal: true

# == Schema Information
#
# Table name: frames
#
#  id           :bigint           not null, primary key
#  comment      :text
#  creator_name :string
#  file_data    :text
#  joined_tags  :string
#  name         :string           not null
#  private      :boolean          default(FALSE)
#  shooted_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint
#
FactoryBot.define do
  factory :frame do
    name { 'test_frame' }

    trait :skip_validate do
      to_create { |instance| instance.save(validate: false) }
    end
  end
end
