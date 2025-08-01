# frozen_string_literal: true

# queries
module Queries
  # users
  module Users
    # Pagination module
    module Pagination
      extend ActiveSupport::Concern

      include Pagy::Backend

      protected

      def list_frames_query(user_id:, page:)
        frames = Queries::Users::ListPublicFrames.run(user_id:)
        pagy, frames = pagy(frames, page:)
        pagination = Api::Pagination.resources_with_pagination(pagy)
        [ pagination, frames ]
      end
    end
  end
end
