# frozen_string_literal: true

# mutations
module Mutations
  # comments
  module Comments
    # UpdateComment class
    class UpdateComment
      include Mutation

      attr_reader :comment

      def initialize(comment:, form:)
        @comment = comment
        @form = form
      end

      def execute
        comment.attributes = @form
        mutation = Mutations::Comments::SaveComment.run(comment:)
        errors.merge!(mutation.errors) unless mutation.success?
      end
    end
  end
end
