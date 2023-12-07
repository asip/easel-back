# frozen_string_literal: true

# mutations
module Mutations
  # comments
  module Comments
    # DeleteComment
    class DeleteComment
      include Mutation

      attr_reader :comment

      def initialize(user:, comment_id:)
        @user = user
        @comment_id = comment_id
      end

      def execute
        @comment = Comment.find_by!(id: @comment_id, user_id: @user.id)
        @comment.destroy
        @comment
      end
    end
  end
end
