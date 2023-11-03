# frozen_string_literal: true

# query
module Query
  # pagination
  module Pagination
    # UserQuery module
    module UserQuery
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
