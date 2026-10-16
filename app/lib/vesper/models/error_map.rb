# frozen_string_literal: true

#
# Vesper::Models::ErrorMap class
#
class Vesper::Models::ErrorMap
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :detail, :string
  attribute :source, :string

  def initialize(attributes)
    super(attributes)
  end

  def to_h
    attributes.with_indifferent_access
  end
end
