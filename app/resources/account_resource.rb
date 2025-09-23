# frozen_string_literal: true

# Account Resource
class AccountResource < UserResource
  root_key :user, :users
  attributes :email, :time_zone

  attribute :social_login, &:social_login?
end
