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
  include Errors::Login
  include ::Login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :validatable # , :registerable, :recoverable, :rememberable,

  # validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, on: %i[create update]
  # validates :password, length: { minimum: 6, maximum: 128 }, confirmation: true,
  #                      if: -> { new_record? || changes[:crypted_password] },
  #                      on: %i[create update]

  # validates :email, presence: true, on: :login
  # validates :password, presence: true, on: :login
end
