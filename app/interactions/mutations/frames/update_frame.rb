# frozen_string_literal: true

# Mutations::Frames::UpdateFrame class
class Mutations::Frames::UpdateFrame
  include Mutation

  attr_reader :frame

  def initialize(frame:, form:)
    @frame = frame
    @form = form
  end

  def execute
    frame.attributes = @form
    mutation = Mutations::Frames::SaveFrame.run(frame:)
    errors.merge!(mutation.errors) unless mutation.success?
  end
end
