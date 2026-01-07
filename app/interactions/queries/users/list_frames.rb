# frozen_string_literal: true

# queries
module Queries
  # frames
  module Users
    # ListFrames class
    class ListFrames
      include Query

      def initialize(user:)
        @user = user
      end

      def execute
        @user.frames.order('frames.created_at': "desc")
      end
    end
  end
end
