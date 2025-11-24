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
        self.frame = frame
      end

      def execute
        frame.user_id = @user.id
        return if frame.save

        errors.merge!(frame.errors)
      end

      private

      def frame=(frame)
        @frame = frame
      end
    end
  end
end
