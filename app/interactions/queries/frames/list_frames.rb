# frozen_string_literal: true

# queries
module Queries
  # frames
  module Frames
    # ListFrames
    class ListFrames
      include Query

      def initialize(word:)
        @word = word
      end

      def execute
        Frame.eager_load(:user).search_by(word: @word).order(created_at: "desc")
      end
    end
  end
end
