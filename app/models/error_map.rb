# frozen_string_literal: true

#
# ErrorMap class
#
class ErrorMap
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :errors, :array, default: []
  attribute :source, :string

  def initialize(attributes)
    super(attributes)
  end

  def to_h
    attributes.with_indifferent_access
  end
end
