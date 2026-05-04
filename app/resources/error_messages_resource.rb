# frozen_string_literal: true

# ErrorMessages Resource
class ErrorMessagesResource < ApplicationResource
  attributes :errors

  typelize errors: "Record<string, string[]>"
end
