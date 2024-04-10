# frozen_string_literal: true

# queries
module Queries
  # frames
  module Users
    # ListFrames
    class PublicListFrames
      include Query

      def initialize(user_id:)
        @user_id = user_id
      end

      def execute
        User.find_by!(id: @user_id).frames.where('frames.private': false).order('frames.created_at': "desc")
      end
    end
  end
end
