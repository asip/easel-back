# frozen_string_literal: true

# TagList Resource
class TagListResource < ApplicationResource
  attributes :tags

  typelize tags: "string[]"
end
