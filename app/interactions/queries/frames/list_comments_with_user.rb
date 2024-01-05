# frozen_string_literal: true

# queries
module Queries
  # frames
  module Frames
    # ListCommentsWithUser module
    class ListCommentsWithUser
      include Query

      def initialize(frame_id:)
        @frame_id = frame_id
      end

      def execute
        frame = Frame.find_by!(id: @frame_id)
        User.unscoped do
          Comment.eager_load(:user).where(frame_id: frame.id)
                 .order(created_at: "asc")
        end
      end
    end
  end
end
