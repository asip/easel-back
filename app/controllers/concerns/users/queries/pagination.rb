# frozen_string_literal: true

# Users::Queries::Pagination module
module Users::Queries::Pagination
  extend ActiveSupport::Concern

  include Pagy::Method

  protected

  def list_frames(user_id:, page:)
    frames = Queries::Users::ListPublicFrames.run(user_id:)
    pagy, frames = pagy(frames, page:)
    pagination = Api::Pagination.resources_with_pagination(pagy)
    [ pagination, frames ]
  end
end
