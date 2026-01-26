# frozen_string_literal: true

# Mutations::Frame::SaveFrame class
class Mutations::Frame::SaveFrame
  include Mutation

  attr_reader :frame

  def initialize(frame:)
    @frame = frame
  end

  def execute
    return if frame.save

    errors.merge!(frame.errors)
  end
end
