# frozen_string_literal: true

# comment api controller
class Api::V1::CommentsController < Api::V1::ApiController
  def create
    frame = Queries::Frames::FindFrame.run(user: current_user, frame_id: params[:frame_id])

    mutation = Mutations::Comments::CreateComment.run(user: current_user, frame_id: frame.id,
                                                          form: form_params)
    comment = mutation.comment
    if mutation.success?
      # logger.debug CommentResource.new(comment).serialize
      render json: CommentResource.new(comment).serializable_hash
    else
      render json: { errors: comment.errors.to_hash(false) }.to_json, status: :unprocessable_content
    end
  end

  def update
    frame = Queries::Frames::FindFrame.run(user: current_user, frame_id: params[:frame_id])
    comment = Queries::Comments::FindComment.run(user: current_user, frame_id: frame.id, comment_id: params[:id])

    mutation = Mutations::Comments::UpdateComment.run(comment:, form: form_params)
    comment = mutation.comment
    if mutation.success?
      # logger.debug CommentResource.new(comment).serialize
      render json: CommentResource.new(comment).serializable_hash
    else
      render json: { errors: comment.errors.to_hash(false) }.to_json, status: :unprocessable_content
    end
  end

  def destroy
    frame = Queries::Frames::FindFrame.run(user: current_user, frame_id: params[:frame_id])
    comment = Queries::Comments::FindComment.run(user: current_user, frame_id: frame.id, comment_id: params[:id])

    Mutations::Comments::DeleteComment.run(comment:)
    head :no_content
  end

  private

  def form_params
    @form_params ||= params.expect(comment: [ :body ]).to_h
  end
end
