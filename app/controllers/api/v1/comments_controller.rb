# frozen_string_literal: true

# api
module Api
  # v1
  module V1
    # Comments Controller
    class CommentsController < Api::V1::ApiController
      skip_before_action :switch_locale, only: [:index]
      skip_before_action :authenticate, only: [:index]

      def index
        comments = Comment.where(frame_id: params[:frame_id])

        # options = {}
        # options[:include] = [:user]

        render json: CommentSerializer.new(comments).serializable_hash
      end

      def create
        comment = Comment.new(comment_params)
        comment.user_id = current_user.id

        if comment.save
          # logger.debug CommentSerializer.new(comment).serialized_json
          render json: CommentSerializer.new(comment).serializable_hash
        else
          render json: { errors: commet.errors.messages }.to_json
        end
      end

      def destroy
        comment = Comment.find_by(id: params[:id])
        comment.destroy if logged_in? && comment && current_user.id == comment.user_id
        head :no_content
      end

      private

      def comment_params
        params.require(:comment).permit(:body, :frame_id)
      end
    end
  end
end
