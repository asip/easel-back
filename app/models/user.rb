# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                         :bigint           not null, primary key
#  crypted_password           :string(255)
#  email                      :string(255)      not null
#  failed_logins_count        :integer          default(0)
#  image_data                 :text(65535)
#  last_activity_at           :datetime
#  last_login_at              :datetime
#  last_login_from_ip_address :string(255)
#  last_logout_at             :datetime
#  lock_expires_at            :datetime
#  name                       :string(255)      not null
#  salt                       :string(255)
#  token                      :string(255)
#  unlock_token               :string(255)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_users_on_email                                (email) UNIQUE
#  index_users_on_last_logout_at_and_last_activity_at  (last_logout_at,last_activity_at)
#  index_users_on_name_and_email                       (name,email) UNIQUE
#  index_users_on_token                                (token) UNIQUE
#  index_users_on_unlock_token                         (unlock_token)
#

# User
class User < ApplicationRecord
  include Page::Confirmable
  include Profile::Image::Uploader::Attachment(:image)

  authenticates_with_sorcery!

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  has_many :frames, dependent: :destroy
  has_many :comments, dependent: :destroy

  # フォローをした、されたの関係
  has_many :follower_relationships, class_name: 'FollowRelationship', foreign_key: 'follower_id',
                                    inverse_of: :follower, dependent: :destroy
  has_many :followee_relationships, class_name: 'FollowRelationship', foreign_key: 'followee_id',
                                    inverse_of: :followee, dependent: :destroy

  # 一覧画面で使う
  has_many :followees, through: :follower_relationships, source: :followee
  has_many :followers, through: :followee_relationships, source: :follower

  # VALID_NAME_REGEX = /\A\z|\A[a-zA-Z\d\s]{3,40}\z/
  VALID_EMAIL_REGEX = /\A\z|\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  with_options on: :with_validation do |save|
    save.validates :name, presence: true, length: { in: 3..40 } # , format: { with: VALID_NAME_REGEX }

    save.validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }

    save.validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
    save.validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
    save.validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  end

  with_options on: :login do
    validates :email, presence: true
    validates :password, presence: true
  end

  def image_url_for_view(key)
    if image.blank?
      '/no-profile-image.png'
    else
      image_url(key)
    end
  end

  def token_expire?
    User.decode_token(token)
    # Rails.logger.debug(decode_token[0]['exp'])
    # decode_token[0]['exp'] < Time.zone.now.to_i
    false
  rescue StandardError # => e
    true
  end

  # rubocop:disable Rails/SkipsModelValidations
  def assign_token(token_)
    update_attribute(:token, token_)
  end
  # rubocop:enable Rails/SkipsModelValidations

  def reset_token
    update!(token: nil)
  end

  # フォローしたときの処理
  def follow(user_id)
    follower_relationships.create(followee_id: user_id)
  end

  # フォローを外すときの処理
  def unfollow(user_id)
    follower_relationships.find_by(followee_id: user_id).destroy
  end

  # フォローしているか判定
  def following?(user)
    followees.include?(user)
  end

  def social_login?
    authentications.present?
  end
end
