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
        comment = Comment.find_by!(id: @comment_id, user_id: @user.id)
        comment.destroy
        self.comment = comment
      end

      private

      def comment=(comment)
        @comment = comment
      end
    end
  end
end
