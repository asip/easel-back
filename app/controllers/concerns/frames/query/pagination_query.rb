# frozen_string_literal: true

# frames
module Frames
  # query
  module Query
    # PaginationQuery module
    module PaginationQuery
      extend ActiveSupport::Concern

      include Pagy::Backend
      include ::Pagination

      def list_query(word:, page:)
        frames = @case.list_query(word:)
        pagy, frames = pagy(frames, { page: })
        frame_ids = frames.pluck(:id)
        frames = Frame.where(id: frame_ids).order(created_at: 'desc')
        pagination = resources_with_pagination(pagy)
        [pagination, frames]
      end
    end
  end
end