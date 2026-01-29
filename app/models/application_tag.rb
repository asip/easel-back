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
class ApplicationTag < ApplicationRecord
  include NoFlyList::ApplicationTag

  # has_many :taggings, class_name: "ApplicationTagging", dependent: :destroy

  scope :search_by, ->(name:) do
    if name.present?
      where("name like ?", "#{ActiveRecord::Base.sanitize_sql_like(name)}%")
    else
      none
    end
  end
end
