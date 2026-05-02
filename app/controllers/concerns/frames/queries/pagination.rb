# frozen_string_literal: true

# Frames::Queries::Pagination module
module Frames::Queries::Pagination
  extend ActiveSupport::Concern

  include Pagy::Method

  protected

  def list_frames(user:, form:, page:)
    frame_ids = Queries::Frame::ListFrameIds.run(user:, form:)
    pagy, frame_ids = pagy(frame_ids, page:)
    frames = Queries::Frame::ListByFrameIds.run(frame_ids:)

    pagination = Api::Pagination.pagination_resources(pagy)
    [ pagination, frames ]
  end
end
