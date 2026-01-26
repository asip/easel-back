# frozen_string_literal: true

# Mutations::Comment::DeleteComment class
class Mutations::Comment::DeleteComment
  include Mutation

  attr_reader :comment

  def initialize(comment:)
    @comment = comment
  end

  def execute
    comment.destroy
  end
end
