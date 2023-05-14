# frozen_string_literal: true

# == Schema Information
#
# Table name: admins
#
#  id                         :bigint           not null, primary key
#  crypted_password           :string(255)
#  email                      :string(255)      not null
#  failed_logins_count        :integer          default(0)
#  last_activity_at           :datetime
#  last_login_at              :datetime
#  last_login_from_ip_address :string(255)
#  last_logout_at             :datetime
#  lock_expires_at            :datetime
#  salt                       :string(255)
#  unlock_token               :string(255)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_admins_on_email                                (email) UNIQUE
#  index_admins_on_last_logout_at_and_last_activity_at  (last_logout_at,last_activity_at)
#  index_admins_on_unlock_token                         (unlock_token)
#
class Admin < ApplicationRecord
  authenticates_with_sorcery!

  VALID_EMAIL_REGEX = /\A\z|\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  with_options on: %i[create update] do |save|
    save.validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }

    save.validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
    save.validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
    save.validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  end

  with_options on: :login do
    validates :email, presence: true
    validates :password, presence: true
  end
end
