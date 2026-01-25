# frozen_string_literal: true

# Frames::Queries::Pagination module
module Frames::Queries::Pagination
  extend ActiveSupport::Concern

  include Pagy::Method

  protected

  def list_frames(user:, form:, page:)
    frame_ids = Queries::Frames::ListFrameIds.run(user:, form:)
    pagy, frame_ids = pagy(frame_ids, page:)
    frames = Frame.eager_load(:user).where(id: frame_ids).order(created_at: "desc")

    pagination = Api::Pagination.resources_with_pagination(pagy)
    [ pagination, frames ]
  end
end
