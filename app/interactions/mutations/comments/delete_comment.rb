# frozen_string_literal: true

# Mutations::Comments::DeleteComment class
class Mutations::Comments::DeleteComment
  include Mutation

  attr_reader :comment

  def initialize(comment:)
    @comment = comment
  end

  def execute
    comment.destroy
  end
end
