# frozen_string_literal: true

# Following Resource
class FollowingResource < ApplicationResource
  attributes :following

  typelize following: :boolean
end
