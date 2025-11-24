# frozen_string_literal: true

# mutations
module Mutations
  # frames
  module Frames
    # CreateFrame
    class CreateFrame
      include Mutation

      attr_reader :frame

      def initialize(user:, form_params:)
        @user = user
        @form_params = form_params
      end

      def execute
        frame = Frame.new(@form_params)
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
