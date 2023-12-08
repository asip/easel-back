# frozen_string_literal: true

# users
module Users
  # query
  module Query
    # Pagination module
    module Pagination
      extend ActiveSupport::Concern

      include Pagy::Backend
      include Api::Pagination

      def frames_query(user_id:, page:)
        frames = Queries::Users::ListFrames.run(user_id:)
        pagy, frames = pagy(frames, { page: })
        pagination = resources_with_pagination(pagy)
        [pagination, frames]
      end
    end
  end
end
