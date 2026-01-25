# frozen_string_literal: true

# Mutations::Comments::CreateComment class
class Mutations::Comments::CreateComment
  include Mutation

  attr_reader :comment

  def initialize(user:, frame_id:, form:)
    @user = user
    @frame_id = frame_id
    @form = form
  end

  def execute
    comment = Comment.new(@form)
    comment.frame_id = @frame_id
    comment.user_id = @user.id
    mutation = Mutations::Comments::SaveComment.run(comment:)
    errors.merge!(mutation.errors) unless mutation.success?
    self.comment = mutation.comment
  end

  private

  def comment=(comment)
    @comment = comment
  end
end
