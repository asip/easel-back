# frozen_string_literal: true

# mutations
module Mutations
  # frames
  module Frames
    # SaveFrame
    class SaveFrame
      include Mutation

      attr_reader :frame

      def initialize(user:, frame:)
        @user = user
        @frame = frame
      end

      def execute
        @frame.user_id = @user.id
        return if @frame.save

        errors.merge!(@frame.errors)
      end
    end
  end
end
