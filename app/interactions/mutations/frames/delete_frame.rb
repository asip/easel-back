# frozen_string_literal: true

# mutations
module Mutations
  # frames
  module Frames
    # DeleteFrame
    class DeleteFrame
      include Mutation

      attr_reader :frame

      def initialize(user:, frame_id:)
        @user = user
        @frame_id = frame_id
      end

      def execute
        @frame = Frame.find_by!(id: @frame_id, user_id: @user.id)
        @frame.destroy
        @frame
      end
    end
  end
end
