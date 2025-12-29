# frozen_string_literal: true

# == Schema Information
#
# Table name: authentications
#
#  id         :bigint           not null, primary key
#  provider   :string           not null
#  uid        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_authentications_on_provider_and_uid  (provider,uid)
#

# Authentication
class Authentication < ApplicationRecord
  include Login::Save

  belongs_to :user, -> { with_discarded }
end
