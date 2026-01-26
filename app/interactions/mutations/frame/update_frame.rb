# frozen_string_literal: true

# Mutations::Frame::UpdateFrame class
class Mutations::Frame::UpdateFrame
  include Mutation

  attr_reader :frame

  def initialize(frame:, form:)
    @frame = frame
    @form = form
  end

  def execute
    frame.attributes = @form
    mutation = Mutations::Frame::SaveFrame.run(frame:)
    errors.merge!(mutation.errors) unless mutation.success?
  end
end
