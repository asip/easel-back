# frozen_string_literal: true

# mutations
module Mutations
  # frames
  module Frames
    # UpdateFrame
    class UpdateFrame
      include Mutation

      attr_reader :frame

      def initialize(frame:, form:)
        @frame = frame
        @form = form
      end

      def execute
        frame.attributes = @form
        mutation = Mutations::Frames::SaveFrame.run(frame:)
        errors.merge!(mutation.errors) unless mutation.success?
      end
    end
  end
end
