# frozen_string_literal: true

#
# Following class
#
class Following
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :following, :boolean, default: false

  def initialize(attributes)
    super(attributes)
  end

  def to_h
    attributes.with_indifferent_access
  end
end
