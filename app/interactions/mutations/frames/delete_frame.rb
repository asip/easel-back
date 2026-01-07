# frozen_string_literal: true

# mutations
module Mutations
  # frames
  module Frames
    # DeleteFrame class
    class DeleteFrame
      include Mutation

      attr_reader :frame

      def initialize(frame:)
        @frame = frame
      end

      def execute
        frame.destroy
      end
    end
  end
end
