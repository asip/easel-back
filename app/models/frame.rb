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

# Frame
class Frame < ApplicationRecord
  include Page::Confirmable
  # has_one_attached :file
  include Contents::Uploader::Attachment(:file)
  include DateAndTime::Util

  acts_as_taggable_on :tags

  has_many :comments, dependent: :destroy
  belongs_to :user

  validates :name, length: { in: 1..20 }
  validates :file, presence: true
  validate :check_tag

  scope :search_by, lambda { |word:|
    scope = current_scope || relation

    if word.present?
      scope = if date_valid?(word)
                date_word = Time.zone.parse(word)
                scope.where(shooted_at: date_word.beginning_of_day..date_word.end_of_day)
                     .or(Frame.where(updated_at: date_word.beginning_of_day..date_word.end_of_day))
              else
                scope.left_joins(:tags, :user)
                     .merge(ActsAsTaggableOn::Tag.where('tags.name like ?',
                                                        "#{ActiveRecord::Base.sanitize_sql_like(word)}%"))
                     .or(Frame.where('frames.name like ?', "#{ActiveRecord::Base.sanitize_sql_like(word)}%"))
                     .or(User.where(name: word))
              end
    end

    scope
  }

  delegate :name, to: :user, prefix: true

  def tags_preview
    tag_list.to_s.split(/\s*,\s*/)
  end

  def assign_derivatives
    return if file.blank?

    file_derivatives!
    save!(validate: false)
  end

  private

  def check_tag
    errors.add(:tag_list, I18n.t('validations.message.frame.tags.array_length')) if tags_preview.size > 5
    tags_preview.each do |tag|
      if tag.to_s.size > 10
        errors.add(:tag_list, I18n.t('validations.message.frame.tags.length'))
        break
      end
    end
  end
end
