# frozen_string_literal: true

# Queries::Frame::ListByFrameIds class
class Queries::Frame::ListByFrameIds
  include Query

  def initialize(frame_ids:)
    @frame_ids = frame_ids
  end

  def execute
    Frame.eager_load(:user).where(id: @frame_ids).order(created_at: "desc")
  end
end
