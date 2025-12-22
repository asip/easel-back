# frozen_string_literal: true

#
# AuthInfo Class
#
class AuthInfo
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :uid, :string
  attribute :provider, :string
  attribute :name, :string
  attribute :email, :string

  def initialize(attributes)
    super(attributes)
  end

  def to_h
    attributes.with_indifferent_access
  end
end
