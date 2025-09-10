# frozen_string_literal: true

# queries
module Queries
  # frames
  module Frames
    # ListFrames
    class ListFrames
      include Query

      def initialize(items:)
        @items = items
      end

      def execute
        Frame.where(private: false).search_by(items: @items).order(created_at: "desc")
      end
    end
  end
end
