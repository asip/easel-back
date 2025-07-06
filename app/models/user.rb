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

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
  devise :omniauthable, omniauth_providers: [ :google_oauth2 ]

  self.discard_column = :deleted_at

  attr_reader :token

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
  #                     if: -> { new_record? || changes[:encrypted_password] }
  validates :name, length: { minimum: 3, maximum: 40 }, unless: -> { validation_context == :login } # , format: { with: VALID_NAME_REGEX }
  # validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP },
  #                   uniqueness: true

  # after_validation :assign_derivatives

  default_scope -> { kept }

  def self.from_omniauth(auth)
    uid = auth[:uid]
    provider = auth[:provider]
    info = auth[:info] || {}

    authentication = Authentication.find_by(uid: uid, provider: provider)

    if authentication
      info_email = info["email"]
      user = update_email(id: authentication.user_id, email: info_email) if info_email.present?
    else
      user = update_info(info: info, provider: provider, uid: uid)
    end

    user
  end

  def self.update_email(id:, email:)
    user = User.find_by(id: id)
    if user
      user.email = email
      user.save!
    end

    user
  end

  def self.update_info(info:, provider:, uid:)
    email = info["email"]
    name = info["name"]

    user = User.find_by(email: email)

    ActiveRecord::Base.transaction do
      unless user
        user = User.new
        user.name = name
        user.email = email
        user.password = Devise.friendly_token[0, 20]
        # puts user.errors.to_hash(false)
        user.save!
      end

      authentication = Authentication.new
      authentication.user_id = user.id
      authentication.provider = provider
      authentication.uid = uid
      authentication.save!
    end

    user
  end

  def image_proxy_url(key)
    if image.present?
      case key.to_s
      when "thumb"
        image.imgproxy_url(width: 50, height: 50, resizing_type: :fill)
      when "one"
        image.imgproxy_url(width: 100, height: 100, resizing_type: :fill)
      when "three"
        image.imgproxy_url(width: 300, height: 300, resizing_type: :fill)
      end
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

  def assign_token(token_)
    @token = token_
  end

  def update_token
    # return unless saved_change_to_email?
  end

  # def assign_derivatives
  #   return if image.blank?
  #   return unless errors[:image].empty?
  #
  #   image_derivatives!
  # end

  def reset_token
    @token = nil
  end

  # (フォローしたときの処理)
  def follow(user_id)
    follower_relationships.create(followee_id: user_id)
  end

  # (フォローを外すときの処理)
  def unfollow(user_id)
    follower_relationships.find_by(followee_id: user_id)&.destroy
  end

  # (フォローしているか判定)
  def following?(user)
    followees.include?(user)
  end

  def social_login?
    authentications.present?
  end

  def self.validate_login(form_params:)
    user = User.find_by(email: form_params[:email])
    if user
      user.validate_password_on_login(form_params)
    else
      user = User.new(form_params)
      user.validate_email_on_login(form_params)
    end
    success = user.errors.empty?
      [ success, user ]
  end

  def validate_password_on_login(form_params)
    self.password = form_params[:password]
    valid?(:login)
    errors.add(:password, I18n.t("action.login.invalid")) if form_params[:password].present?
  end

  def validate_email_on_login(form_params)
    valid?(:login)
    errors.add(:email, I18n.t("action.login.invalid")) if form_params[:email].present?
  end
end
