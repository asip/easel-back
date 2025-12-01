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

# Frame
class Frame < ApplicationRecord
  # has_one_attached :file
  include Contents::Uploader::Attachment(:file)
  include NoFlyList::TaggableRecord

  has_tags :tags, polymorphic: true

  has_many :comments, dependent: :destroy
  belongs_to :user, -> { with_discarded }

  delegate :name, to: :user, prefix: true

  validates :name, length: { in: 1..30 }
  validates :file, presence: true
  validates :creator_name, length: { maximum: 40 }
  validates :shooted_at_before_type_cast, datetime: true
  validates :private_before_type_cast, inclusion: { in: [ "true", "false", true, false ] }
  validate :validate_tag

  # after_validation :assign_derivatives

  scope :search_by, ->(user:, items:) do
    scope = current_scope || relation

    word = items[:word]
    frame_name = items[:frame_name]
    tag_name = items[:tag_name]
    user_name = items[:user_name]
    creator_name = items[:creator_name]
    date = items[:date]

    scope = scope.where(private: false)

    if user.present?
      scope = scope.or(Frame.where(user_id: user.id, private: true))
    end

    if word.present?
      scope = if DateAndTime::Util.valid_date?(word)
                date_word = Time.zone.parse(word)
                scope.merge(
                  Frame.where(shooted_at: date_word.beginning_of_day..date_word.end_of_day)
                       .or(Frame.where(created_at: date_word.beginning_of_day..date_word.end_of_day))
                       .or(Frame.where(updated_at: date_word.beginning_of_day..date_word.end_of_day))
                )

      else
                scope.merge(
                  Frame.left_joins(:user)
                       .merge(Frame.tags_with(tag_name: word))
                       .or(Frame.where("frames.name like ?", "#{ActiveRecord::Base.sanitize_sql_like(word)}%"))
                       .or(Frame.where("frames.creator_name like ?", "#{ActiveRecord::Base.sanitize_sql_like(word)}%"))
                       .or(User.where("users.name like ?", "#{ActiveRecord::Base.sanitize_sql_like(word)}%"))
                )
      end
    else
      if frame_name.present?
        scope = scope.where("frames.name like ?", "#{ActiveRecord::Base.sanitize_sql_like(frame_name)}%")
      end

      if tag_name.present?
        scope = scope.merge(Frame.tags_with(tag_name:))
      end

      if user_name.present?
        scope = scope.merge(
          Frame.left_joins(:user)
               .merge(
                  User.where("users.name like ?", "#{ActiveRecord::Base.sanitize_sql_like(user_name)}%")
               )
        )
      end

      if creator_name.present?
        scope = scope.where("frames.creator_name like ?", "#{ActiveRecord::Base.sanitize_sql_like(creator_name)}%")
      end

      if date.present?
        scope = scope.merge(
          Frame.where(shooted_at: date.beginning_of_day..date.end_of_day)
               .or(Frame.where(created_at: date.beginning_of_day..date.end_of_day))
               .or(Frame.where(updated_at: date.beginning_of_day..date.end_of_day))
        )
      end
    end

    # puts scope.to_sql
    scope
  end

  scope :tags_with, ->(tag_name:) do
    where(
      "EXISTS(:tags)",
      tags: ApplicationTag.joins(:taggings)
                  .where("application_taggings.tag_id=application_tags.id")
                  .where("application_taggings.taggable_type='Frame'")
                  .where("application_taggings.taggable_id=frames.id")
                  .where("application_tags.name like ?",
                         "#{ActiveRecord::Base.sanitize_sql_like(tag_name)}%")
    )
  end

  def tag_list
    joined_tags
  end

  def tag_list=(tags_list)
    self.tags_list = tags_list
    self.joined_tags = tags_list
  end

  def plain_tags
    joined_tags&.split(",")
  end

  def file_proxy_url(key)
    # puts key
    case key.to_s
    when "original"
      file&.imgproxy_url
    when "two"
      file&.imgproxy_url(width: 240, height: 240, resizing_type: :fit)
    when  "three"
      file&.imgproxy_url(width: 320, height: 320, resizing_type: :fit)
    when  "six"
      file&.imgproxy_url(width: 640, height: 640, resizing_type: :fit)
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

  def validate_tag
    errors.add(:tag_list, I18n.t("validations.message.frame.tags.array_length")) if plain_tags.size > 5
    plain_tags.each do |tag|
      if tag.to_s.size > 10
        errors.add(:tag_list, I18n.t("validations.message.frame.tags.length"))
        break
      end
    end
  end
end
