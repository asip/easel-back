# frozen_string_literal: true

# mutations
module Mutations
  # frames
  module Frames
    # UpdateFrame
    class UpdateFrame
      include Mutation

      attr_reader :frame

      def initialize(user:, frame_id:, form:)
        @user = user
        @frame_id = frame_id
        @form = form
      end

      def execute
        frame = Frame.find_by!(id: @frame_id, user_id: @user.id)
        frame.attributes = @form
        mutation = Mutations::Frames::SaveFrame.run(user: @user, frame:)
        errors.merge!(mutation.errors) unless mutation.success?
        self.frame = mutation.frame
      end

      private

      def frame=(frame)
        @frame = frame
      end
    end
  end
end
