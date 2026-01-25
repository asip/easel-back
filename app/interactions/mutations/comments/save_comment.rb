# frozen_string_literal: true

# Mutations::Comments::SaveComment class
class Mutations::Comments::SaveComment
  include Mutation

  attr_reader :comment

  def initialize(comment:)
    @comment = comment
  end

  def execute
    return if comment.save

    errors.merge!(comment.errors)
  end
end
