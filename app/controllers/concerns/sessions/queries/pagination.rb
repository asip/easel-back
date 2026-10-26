# frozen_string_literal: true

# Sessions::Queries::Pagination module
module Sessions::Queries::Pagination
  extend ActiveSupport::Concern

  include Pagy::Method

  protected

  def list_frames(user:, page:)
    frames = Queries::User::ListFrames.run(user:)
    pagy, frames = pagy(frames, page:)
    pagination = Api::Pagination::Pagy.pagination_resource(pagy)
    [ pagination, frames ]
  end
end
