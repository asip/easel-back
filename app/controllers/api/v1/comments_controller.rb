# frozen_string_literal: true

# comment api controller
class Api::V1::CommentsController < Api::V1::ApiController
  def create
    frame = Queries::Frame::FindFrame.run(user: current_user, frame_id: params[:frame_id])

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
    frame = Queries::Frame::FindFrame.run(user: current_user, frame_id: params[:frame_id])
    comment = Queries::Comment::FindComment.run(user: current_user, frame_id: frame.id, comment_id: params[:id])

    mutation = Mutations::Comment::UpdateComment.run(comment:, form: form_params)
    comment = mutation.comment
    if mutation.success?
      render_comment(comment:)
    else
      render_errors(resource: comment)
    end
  end

  def destroy
    frame = Queries::Frame::FindFrame.run(user: current_user, frame_id: params[:frame_id])
    comment = Queries::Comment::FindComment.run(user: current_user, frame_id: frame.id, comment_id: params[:id])

    Mutations::Comment::DeleteComment.run(comment:)
    head :no_content
  end

  private

  def form_params
    @form_params ||= params.expect(comment: [ :body ]).to_h
  end
end
