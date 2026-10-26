# frozen_string_literal: true

require_relative "errors_without_before_type_cast"

module ActiveModel
  # ActiveModel::Errors class
  class Errors
    prepend ActiveModel::ErrorsWithoutBeforeTypeCast
  end
end
