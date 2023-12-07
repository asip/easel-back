# frozen_string_literal: true

# mutations
module Mutations
  # comments
  module Comments
    # CreateComment
    class CreateComment
      include Mutation

      attr_reader :comment

      def initialize(user:, frame_id:, form_params:)
        @user = user
        @frame_id = frame_id
        @form_params = form_params
      end

      def execute
        comment = Comment.new(@form_params)
        mutation = Mutations::Comments::SaveComment.run(user: @user, frame_id: @frame_id, comment:)
        errors.merge!(mutation.errors) unless mutation.success?
        @comment = mutation.comment
      end
    end
  end
end
