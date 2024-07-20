# frozen_string_literal: true

# queries
module Queries
  # sessions
  module Sessions
    # Pagination module
    module Pagination
      extend ActiveSupport::Concern

      include Pagy::Backend
      include Api::Pagination

      def list_frames_query(user:, page:)
        frames = Queries::Users::ListFrames.run(user:)
        pagy, frames = pagy(frames, page:)
        pagination = resources_with_pagination(pagy)
        [ pagination, frames ]
      end
    end
  end
end
