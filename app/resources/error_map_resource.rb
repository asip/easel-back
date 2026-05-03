# frozen_string_literal: true

# ErrorMessages Resource
class ErrorMapResource < ApplicationResource
  attributes :title, :errors

  attributes :source, if: ->(_error, attribute) { attribute.present? }
end
