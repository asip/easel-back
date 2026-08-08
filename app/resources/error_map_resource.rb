# frozen_string_literal: true

# ErrorMessages Resource
class ErrorMapResource < ApplicationResource
  attributes :title, :detail

  attributes :source, if: ->(_error, attribute) { attribute.present? }

  typelize title: :string, detail: :string, source: "string?"
end
