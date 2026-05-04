# frozen_string_literal: true

# Account Resource
class AccountResource < UserResource
  attributes :email, :time_zone

  attribute :social_login, &:social_login?

  typelize id: :number, name: :string, time_zone: :string
  typelize email: :string, social_login: :boolean
end
