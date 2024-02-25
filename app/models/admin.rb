# frozen_string_literal: true

# == Schema Information
#
# Table name: admins
#
#  id                         :bigint           not null, primary key
#  crypted_password           :string
#  email                      :string           not null
#  failed_logins_count        :integer          default(0)
#  last_activity_at           :datetime
#  last_login_at              :datetime
#  last_login_from_ip_address :string
#  last_logout_at             :datetime
#  lock_expires_at            :datetime
#  salt                       :string
#  unlock_token               :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_admins_on_email                                (email) UNIQUE
#  index_admins_on_last_logout_at_and_last_activity_at  (last_logout_at,last_activity_at)
#  index_admins_on_unlock_token                         (unlock_token)
#

# Admin
class Admin < ApplicationRecord
  include Errors::Sortable

  authenticates_with_sorcery!

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: %i[create update]
  validates :password, length: { minimum: 3 }, confirmation: true,
                       if: -> { new_record? || changes[:crypted_password] },
                       on: %i[create update]
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] },
                                    on: %i[create update]

  validates :email, presence: true, on: :login
  validates :password, presence: true, on: :login

  def full_error_messages_on_login
    full_error_messages_for(%i[email password])
  end

  def self.validate_login(form_params:)
    user = Admin.find_by(email: form_params[:email])
    if user
      user.validate_password_on_login(form_params)
    else
      user = Admin.new(form_params)
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
