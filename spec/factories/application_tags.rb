# == Schema Information
#
# Table name: application_tags
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_application_tags_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :application_tag do
    name { 'test_tag' }
  end
end
