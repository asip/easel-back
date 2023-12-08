# frozen_string_literal: true

# api
module Api
  # v1
  module V1
    # Comments Controller
    class CommentsController < Api::V1::ApiController
      def create
        mutation = Mutations::Comments::CreateComment.run(user: current_user, frame_id: params[:frame_id], form_params:)
        comment = mutation.comment
        if mutation.success?
          # logger.debug CommentSerializer.new(comment).serialized_json
          render json: CommentSerializer.new(comment).serializable_hash
        else
          render json: { errors: comment.errors.to_hash(true) }.to_json
        end
      end

      def destroy
        Mutations::Comments::DeleteComment.run(user: current_user, comment_id: params[:id])
        head :no_content
      end

      private

      def form_params
        params.require(:comment).permit(:body)
      end
    end
  end
end
