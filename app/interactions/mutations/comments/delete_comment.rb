# frozen_string_literal: true

# mutations
module Mutations
  # comments
  module Comments
    # DeleteComment class
    class DeleteComment
      include Mutation

      attr_reader :comment

      def initialize(comment:)
        @comment = comment
      end

      def execute
        comment.destroy
      end
    end
  end
end
