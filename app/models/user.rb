# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                 :bigint           not null, primary key
#  deleted_at         :datetime
#  email              :string           not null
#  encrypted_password :string           default(""), not null
#  image_data         :text
#  name               :string           not null
#  profile            :text
#  time_zone          :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_users_on_deleted_at  (deleted_at)
#  index_users_on_email       (email) UNIQUE
#

# User
class User < ApplicationRecord
  include Discard::Model
  include Profile::Image::Uploader::Attachment(:image)
  include Jwt::Token
  include Login
  include Login::Save
  include Follow

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
  devise :omniauthable, omniauth_providers: [ :google ]

  self.discard_column = :deleted_at

  has_many :authentications, dependent: :destroy
  # accepts_nested_attributes_for :authentications

  has_many :frames, dependent: :destroy
  has_many :comments, dependent: :destroy

  # (フォローをした、されたの関係)
  has_many :follower_relationships, class_name: "FollowRelationship", foreign_key: "follower_id",
                                    inverse_of: :follower, dependent: :destroy
  has_many :followee_relationships, class_name: "FollowRelationship", foreign_key: "followee_id",
                                    inverse_of: :followee, dependent: :destroy

  # (一覧画面で使う)
  has_many :followees, through: :follower_relationships, source: :followee
  has_many :followers, through: :followee_relationships, source: :follower

  # VALID_NAME_REGEX = /\A\z|\A[a-zA-Z\d\s]{3,40}\z/

  # validates :password, length: { minimum: 6, maximum: 128 }, confirmation: true,
  #                      if: -> { new_record? || changes[:encrypted_password] }
  validates :name, length: { minimum: 3, maximum: 40 }, unless: -> { validation_context == :login } # , format: { with: VALID_NAME_REGEX }
  # validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP },
  #                   uniqueness: true
  validates :time_zone, presence: true, unless: -> { validation_context == :login }
  validates :profile, length: { maximum: 160 }, unless: -> { validation_context == :login }

  # after_validation :assign_derivatives

  default_scope -> { kept }

  def nonweb_time_zone
    time_zone.present? ? time_zone : Time.zone.name
  end

  ## devise
  # def active_for_authentication?
  #   super && !discarded?
  # end

  def image_proxy_url(key)
    case key.to_s
    # when "original"
    #   image&.imgproxy_url
    when "thumb"
      image&.imgproxy_url(width: 50, height: 50, resizing_type: :fill)
    when "one"
      image&.imgproxy_url(width: 100, height: 100, resizing_type: :fill)
    when "three"
      image&.imgproxy_url(width: 320, height: 320, resizing_type: :fill)
    else
      nil
    end
  end

  def image_url_for_view(key)
    if image.blank?
      "#{Settings.origin}/no-profile-image.png"
    else
      image_proxy_url(key)
    end
  end

  # def assign_derivatives
  #   return if image.blank?
  #   return unless errors[:image].empty?
  #
  #   image_derivatives!
  # end
end
