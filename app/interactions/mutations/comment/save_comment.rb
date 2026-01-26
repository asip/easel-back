# frozen_string_literal: true

# Mutations::Comment::SaveComment class
class Mutations::Comment::SaveComment
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
