# frozen_string_literal: true

# Mutations::Frame::DeleteFrame class
class Mutations::Frame::DeleteFrame
  include Mutation

  attr_reader :frame

  def initialize(frame:)
    @frame = frame
  end

  def execute
    frame.destroy
  end
end
