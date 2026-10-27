# frozen_string_literal: true

module ActiveModel
  # ActiveModel::Errors class
  class Errors
    prepend ActiveModel::ErrorsWithoutBeforeTypeCast
  end
end
