# frozen_string_literal: true

#
# ErrorMessages class
#
class ErrorMessages
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :errors, :hash, default: {}

  def initialize(attributes)
    super(attributes)
  end

  def to_h
    attributes.with_indifferent_access
  end
end
