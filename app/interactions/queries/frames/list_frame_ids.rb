# frozen_string_literal: true

# queries
module Queries
  # frames
  module Frames
    # ListFrameIds
    class ListFrameIds
      include Query

      def initialize(user:, items:)
        @user = user
        @items = items
      end

      def execute
        Frame.select(:id).search_by(user: @user, items: @items).order(created_at: :desc)
      end
    end
  end
end
