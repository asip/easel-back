# frozen_string_literal: true

# users
module Users
  # query
  module Query
    # PaginationQuery module
    module PaginationQuery
      extend ActiveSupport::Concern

      include Pagy::Backend
      include ::Pagination

      def frames_query(user_id:, page:)
        frames = @case.frames_query(user_id:)
        pagy, frames = pagy(frames, { page: })
        pagination = resources_with_pagination(pagy)
        [pagination, frames]
      end
    end
  end
end
