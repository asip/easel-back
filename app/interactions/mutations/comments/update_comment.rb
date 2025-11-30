# frozen_string_literal: true

# mutations
module Mutations
  # comments
  module Comments
    # UpdateComment
    class UpdateComment
      include Mutation

      attr_reader :comment

      def initialize(user:, comment_id:, form:)
        @user = user
        @comment_id = comment_id
        @form = form
      end

      def execute
        comment = Comment.find_by!(id: @comment_id, user_id: @user.id)
        comment.attributes = @form
        mutation = Mutations::Comments::SaveComment.run(user: @user, comment:)
        errors.merge!(mutation.errors) unless mutation.success?
        self.comment = mutation.comment
      end

      private

      def comment=(comment)
        @comment = comment
      end
    end
  end
end
