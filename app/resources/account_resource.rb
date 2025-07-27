# frozen_string_literal: true

# Account Resource
class AccountResource < UserResource
  root_key :user, :users
  attributes :email

  attribute :social_login, &:social_login?
end
