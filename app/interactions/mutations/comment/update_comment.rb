# frozen_string_literal: true

# Mutations::Comment::UpdateComment class
class Mutations::Comment::UpdateComment
  include Mutation

  attr_reader :comment

  def initialize(comment:, form:)
    @comment = comment
    @form = form
  end

  def execute
    comment.attributes = @form
    mutation = Mutations::Comment::SaveComment.run(comment:)
    errors.merge!(mutation.errors) unless mutation.success?
  end
end
