# == Schema Information
#
# Table name: application_taggings
#
#  id            :bigint           not null, primary key
#  context       :string           not null
#  taggable_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  tag_id        :bigint           not null
#  taggable_id   :bigint           not null
#
# Indexes
#
#  index_app_taggings_uniqueness           (taggable_type,taggable_id,context,tag_id) UNIQUE
#  index_application_taggings_on_context   (context)
#  index_application_taggings_on_tag_id    (tag_id)
#  index_application_taggings_on_taggable  (taggable_type,taggable_id)
#
# Foreign Keys
#
#  fk_rails_...  (tag_id => application_tags.id)
#
FactoryBot.define do
  factory :application_tagging do
    taggable_type { 'Frame' }
    context { 'tag' }
  end
end
