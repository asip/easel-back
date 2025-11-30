# frozen_string_literal: true

# mutations
module Mutations
  # comments
  module Comments
    # CreateComment
    class CreateComment
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
