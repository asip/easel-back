# frozen_string_literal: true

# Vesper::Resources::ErrorMessages Resource
class Vesper::Resources::ErrorMessagesResource < ApplicationResource
  attributes :errors

  typelize errors: "Record<string, string[]>"
end
