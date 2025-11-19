# frozen_string_literal: true

# active model
module ActiveModel
  # ErrorsWithoutBeforeTypeCast module
  module ErrorsWithoutBeforeTypeCast
    def add(attribute, message = :invalid, **options)
      attribute = attribute.to_s.sub("_before_type_cast", "").to_sym if attribute.to_s.include?("_before_type_cast")
      super(attribute, message, **options)
    end
  end

  # Errors
  class Errors
    prepend ActiveModel::ErrorsWithoutBeforeTypeCast
  end
end
