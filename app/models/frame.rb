# frozen_string_literal: true

# == Schema Information
#
# Table name: frames
#
#  id          :bigint           not null, primary key
#  comment     :text
#  file_data   :text
#  joined_tags :string
#  name        :string           not null
#  private     :boolean          default(FALSE)
#  shooted_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#

# Frame
class Frame < ApplicationRecord
  # has_one_attached :file
  include Contents::Uploader::Attachment(:file)

  acts_as_taggable_on :tags

  has_many :comments, dependent: :destroy
  belongs_to :user

  delegate :name, to: :user, prefix: true

  validates :name, length: { in: 1..30 }
  validates :file, presence: true
  validate :check_tag

  # after_validation :assign_derivatives

  scope :search_by, lambda { |word:|
    scope = current_scope || relation
    scope = scope.where(private: false)

    if word.present?
      scope = if DateAndTime::Util.valid_date?(word)
                date_word = Time.zone.parse(word)
                scope.merge(
                  Frame.where(shooted_at: date_word.beginning_of_day..date_word.end_of_day)
                       .or(Frame.where(updated_at: date_word.beginning_of_day..date_word.end_of_day))
                )

      else
                scope.merge(
                  Frame.left_joins(:tags, :user)
                       .merge(
                        ActsAsTaggableOn::Tag.where("tags.name like ?",
                                                    "#{ActiveRecord::Base.sanitize_sql_like(word)}%")
                        )
                       .or(Frame.where("frames.name like ?", "#{ActiveRecord::Base.sanitize_sql_like(word)}%"))
                       .or(User.where(name: word))
                )
      end
    end

    scope
  }

  def tags_preview
    tag_list.to_s.split(/\s*,\s*/)
  end

  def tags_display
    joined_tags&.split(/\s*,\s*/)
  end

  def file_proxy_url(key)
    # puts key
    if file.present?
      case key.to_s
      when "original"
        file.url
      when "two"
        file.imgproxy_url(width: 200, height: 200, resizing_type: :fit)
      when  "three"
        file.imgproxy_url(width: 300, height: 300, resizing_type: :fit)
      else
        nil
      end
    else
      nil
    end
  end

  # def assign_derivatives
  #   return if file.blank?
  #   return unless errors[:file].empty?
  #
  #   file_derivatives!
  # end

  private

  def check_tag
    errors.add(:tag_list, I18n.t("validations.message.frame.tags.array_length")) if tags_preview.size > 5
    tags_preview.each do |tag|
      if tag.to_s.size > 10
        errors.add(:tag_list, I18n.t("validations.message.frame.tags.length"))
        break
      end
    end
  end
end
