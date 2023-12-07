# frozen_string_literal: true

# queries
module Queries
  # frames
  module Frames
    # ListFrames module
    class ListFrames
      include Query

      def initialize(word:)
        @word = word
      end

      def execute
        Frame.search_by(word: @word).order(created_at: 'desc')
      end
    end
  end
end
