# frozen_string_literal: true

# mutations
module Mutations
  # comments
  module Comments
    # SaveComment
    class SaveComment
      include Mutation

      attr_reader :comment

      def initialize(comment:)
        @comment = comment
      end

      def execute
        return if comment.save

        errors.merge!(comment.errors)
      end
    end
  end
end
