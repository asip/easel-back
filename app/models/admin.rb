# frozen_string_literal: true

# == Schema Information
#
# Table name: admins
#
#  id                 :bigint           not null, primary key
#  email              :string           not null
#  encrypted_password :string           default(""), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_admins_on_email  (email) UNIQUE
#

# Admin
class Admin < ApplicationRecord
  include Errors::Sortable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :validatable # , :registerable, :recoverable, :rememberable,

  # validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: %i[create update]
  # validates :password, length: { minimum: 6, maximum: 128 }, confirmation: true,
  #                      if: -> { new_record? || changes[:crypted_password] },
  #                      on: %i[create update]

  # validates :email, presence: true, on: :login
  # validates :password, presence: true, on: :login

  def full_error_messages_on_login
    full_error_messages_for(%i[email password])
  end

  def self.validate_login(form_params:)
    admin = Admin.find_for_authentication(email: form_params[:email])
    if admin
      admin.validate_password_on_login(form_params)
    else
      admin = Admin.new(form_params)
      admin.validate_email_on_login(form_params)
    end
    success = admin.errors.empty?
    [ success, admin ]
  end

  def validate_password_on_login(form_params)
    password_ = form_params[:password]
    self.password = password_
    valid?
    errors.add(:password, I18n.t("action.login.invalid")) if password_.present?
  end

  def validate_email_on_login(form_params)
    valid?
    errors.add(:email, I18n.t("action.login.invalid")) if form_params[:email].present?
  end
end
