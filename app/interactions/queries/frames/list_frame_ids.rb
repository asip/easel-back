# frozen_string_literal: true

# queries
module Queries
  # frames
  module Frames
    # ListFrameIds
    class ListFrameIds
      include Query

      def initialize(items:)
        @items = items
      end

      def execute
        Frame.select(:id).where(private: false).search_by(items: @items).order(created_at: :desc)
      end
    end
  end
end
