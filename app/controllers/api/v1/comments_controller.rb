# frozen_string_literal: true

# comment api controller
class Api::V1::CommentsController < Api::V1::ApiController
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

  def route_params
    @route_params ||= params.permit(:id, :frame_id).to_h
  end

  def frame_id
    route_params[:frame_id]
  end

  def comment_id
    route_params[:id]
  end

  def form_params
    @form_params ||= params.expect(comment: [ :body ]).to_h
  end
end
