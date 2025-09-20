# frozen_string_literal: true

# mutations
module Mutations
  # frames
  module Frames
    # SaveFrame
    class SaveFrame
      include Mutation

      attr_reader :frame

      def initialize(user:, frame:, form_params:)
        @user = user
        @frame = frame
        @form_params = form_params
      end

      def execute
        @frame.user_id = @user.id
        @frame.joined_tags = @form_params[:tag_list]
        return if @frame.save

        errors.merge!(@frame.errors)
      end
    end
  end
end
