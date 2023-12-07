# frozen_string_literal: true

# queries
module Queries
  # frames
  module Frames
    # FindFrameWithRelations module
    class FindFrameWithRelations
      include Query

      def initialize(frame_id:)
        @frame_id = frame_id
      end

      def execute
        Frame.eager_load(:user, comments: :user).find_by!(id: @frame_id)
      end
    end
  end
end
