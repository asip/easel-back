# frozen_string_literal: true

# Mutations::Frames::DeleteFrame class
class Mutations::Frames::DeleteFrame
  include Mutation

  attr_reader :frame

  def initialize(frame:)
    @frame = frame
  end

  def execute
    frame.destroy
  end
end
