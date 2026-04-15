# frozen_string_literal: true

# comment api controller
class Api::V1::CommentsController < Api::V1::ApiController
  include Comments::Variables

  def create
    mutation = Mutations::Comment::CreateComment.run(user: current_user, frame_id: frame.id,
                                                     form: form_params)
    comment = mutation.comment
    if mutation.success?
      render_comment(comment:)
    else
      render_errors(resource: comment)
    end
  end

  def update
    mutation = Mutations::Comment::UpdateComment.run(comment:, form: form_params)
    comment = mutation.comment
    if mutation.success?
      render_comment(comment:)
    else
      render_errors(resource: comment)
    end
  end

  def destroy
    Mutations::Comment::DeleteComment.run(comment:)
    head :no_content
  end

  private

  def frame
    Queries::Frame::FindFrame.run(user: current_user, frame_id:)
  end

  def comment
    Queries::Comment::FindComment.run(user: current_user, frame_id: frame.id, comment_id:)
  end
end
