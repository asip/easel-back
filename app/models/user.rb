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
  #                      if: -> { new_record? || changes[:encrypted_password] }
  validates :name, length: { minimum: 3, maximum: 40 }, unless: -> { validation_context == :login } # , format: { with: VALID_NAME_REGEX }
  # validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP },
  #                   uniqueness: true
  validates :time_zone, presence: true, unless: -> { validation_context == :login }, on: :create

  # after_validation :assign_derivatives

  default_scope -> { kept }

  def nonweb_time_zone
    time_zone.present? ? time_zone : Time.zone.name
  end

  ## devise
  # def active_for_authentication?
  #   super && !discarded?
  # end

  def self.from_omniauth(auth)
    uid = auth[:uid]
    provider = auth[:provider]
    time_zone = auth[:time_zone]
    info = auth[:info] || {}

    # (認証レコードを検索)
    authentication = Authentication.find_by(uid: uid, provider: provider)

    if authentication
      info_email = info["email"]
      user = User.unscoped.find_by(id: authentication.user_id)
      update_user_info(user, email: info_email) if info_email.present?
    else
      user = find_or_create_user_from_omniauth(info, time_zone:)
      create_authentication_for_user(user, provider, uid)
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
      else
        nil
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
    user = User.find_for_authentication(email: form_params[:email])
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
    password_ = form_params[:password]
    self.password = password_
    valid?(:login)
    errors.add(:password, I18n.t("action.login.invalid")) if password_.present?
  end

  def validate_email_on_login(form_params)
    valid?(:login)
    errors.delete(:email) if errors[:email].include?(I18n.t("errors.messages.taken"))
    errors.add(:email, I18n.t("action.login.invalid")) if form_params[:email].present?
  end

  private

  def self.update_user_info(user, email:)
    return unless user && email.present?
    if user.email != email
      user.email = email
    end
    user.deleted_at = nil
    user.save!
    user
  end

  def self.find_or_create_user_from_omniauth(info, time_zone:)
    email = info["email"]
    name = info["name"]

    user = User.unscoped.find_for_authentication(email: email)

    unless user
      user = User.new(
        name: name,
        email: email,
        password: Devise.friendly_token[0, 20],
        time_zone:
      )
    else
      user.deleted_at = nil
    end
    user.save!
    user
  end

  def self.create_authentication_for_user(user, provider, uid)
    authentication = Authentication.new(
      user: user,
      provider: provider,
      uid: uid
    )
    authentication.save!
  end
end
