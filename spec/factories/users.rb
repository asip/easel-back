# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                         :bigint           not null, primary key
#  crypted_password           :string
#  deleted_at                 :datetime
#  email                      :string           not null
#  failed_logins_count        :integer          default(0)
#  image_data                 :text
#  last_activity_at           :datetime
#  last_login_at              :datetime
#  last_login_from_ip_address :string
#  last_logout_at             :datetime
#  lock_expires_at            :datetime
#  name                       :string           not null
#  salt                       :string
#  token                      :string
#  unlock_token               :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_users_on_deleted_at                           (deleted_at)
#  index_users_on_email                                (email) UNIQUE
#  index_users_on_last_logout_at_and_last_activity_at  (last_logout_at,last_activity_at)
#  index_users_on_name_and_email                       (name,email)
#  index_users_on_token                                (token) UNIQUE
#  index_users_on_unlock_token                         (unlock_token)
#
FactoryBot.define do
  factory :user do
    name { 'test_user' }
    email { 'test@test.jp' }
  end
end
