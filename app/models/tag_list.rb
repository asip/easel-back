# frozen_string_literal: true

#
# TagList class
#
class TagList
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :tags, :array, default: []

  def initialize(attributes)
    super(attributes)
  end

  def to_h
    attributes.with_indifferent_access
  end
end
