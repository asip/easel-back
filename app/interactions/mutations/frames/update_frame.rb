# frozen_string_literal: true

# mutations
module Mutations
  # frames
  module Frames
    # UpdateFrame
    class UpdateFrame
      include Mutation

      attr_reader :frame

      def initialize(user:, frame_id:, form_params:)
        @user = user
        @frame_id = frame_id
        @form_params = form_params
      end

      def execute
        frame = Frame.find_by!(id: @frame_id, user_id: @user.id)
        frame.attributes = @form_params
        mutation = Mutations::Frames::SaveFrame.run(user: @user, frame:)
        errors.merge!(mutation.errors) unless mutation.success?
        @frame = mutation.frame
      end
    end
  end
end
