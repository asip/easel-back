# frozen_string_literal: true

# Frames::Renderble module
module Frames::Renderable
  extend ActiveSupport::Concern

  protected

  def render_frame(frame)
    render_resource Frame::DetailResource.new(frame).serialize
  end

  def render_frames(frames, pagy:)
    render_resource Frame::List::ItemResource.new(frames).serialize(root_key: :frames, meta: Api::Pagination::Pagy.pagination_resource(pagy))
  end
end
