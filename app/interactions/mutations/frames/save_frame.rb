# frozen_string_literal: true

# mutations
module Mutations
  # frames
  module Frames
    # SaveFrame class
    class SaveFrame
      include Mutation

      attr_reader :frame

      def initialize(frame:)
        @frame = frame
      end

      def execute
        return if frame.save

        errors.merge!(frame.errors)
      end
    end
  end
end
