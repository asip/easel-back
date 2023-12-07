# frozen_string_literal: true

# mutations
module Mutations
  # comments
  module Comments
    # SaveComment
    class SaveComment
      include Mutation

      attr_reader :comment

      def initialize(user:, frame_id:, comment:)
        @user = user
        @frame_id = frame_id
        @comment = comment
      end

      def execute
        @comment.frame_id = @frame_id
        @comment.user_id = @user.id
        return if @comment.save

        errors.merge!(@comment.errors)
      end
    end
  end
end
