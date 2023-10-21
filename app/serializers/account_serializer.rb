# frozen_string_literal: true

# Account Serializer
class AccountSerializer < UserSerializer
  set_type :user

  attributes :token

  attribute :social_login, &:social_login?
end
