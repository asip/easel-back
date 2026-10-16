# frozen_string_literal: true

# Vesper::Resources::ErrorMessagesResource
class Vesper::Resources::ErrorMessagesResource < ApplicationResource
  attributes :errors

  typelize errors: "Record<string, string[]>"
end
