# frozen_string_literal: true

# queries
module Queries
  # frames
  module Frames
    # Pagination module
    module Pagination
      extend ActiveSupport::Concern

      include Pagy::Backend
      include Api::Pagination

      def list_frames_query(word:, page:)
        frames = Queries::Frames::ListFrames.run(word:)
        pagy, frames = pagy(frames, { page: })
        frame_ids = frames.pluck(:id)
        frames = Frame.eager_load(:user).where(id: frame_ids).order(created_at: "desc")
        pagination = resources_with_pagination(pagy)
        [ pagination, frames ]
      end
    end
  end
end
