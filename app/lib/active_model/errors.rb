# frozen_string_literal: true

# active model
module ActiveModel
  # ErrorsWithoutBeforeTypeCast module
  module ErrorsWithoutBeforeTypeCast
    def add(attribute, message = :invalid, **options)
      attr_str = attribute.to_s
      attribute = attr_str.sub("_before_type_cast", "").to_sym if attr_str.include?("_before_type_cast")
      super(attribute, message, **options)
    end
  end

  # Errors class
  class Errors
    prepend ActiveModel::ErrorsWithoutBeforeTypeCast
  end
end
