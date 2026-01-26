# frozen_string_literal: true

# Mutations::Frame::CreateFrame class
class Mutations::Frame::CreateFrame
  include Mutation

  attr_reader :frame

  def initialize(user:, form:)
    @user = user
    @form = form
  end

  def execute
    frame = Frame.new(@form)
    frame.user_id = @user.id
    mutation = Mutations::Frame::SaveFrame.run(frame:)
    errors.merge!(mutation.errors) unless mutation.success?
    self.frame = mutation.frame
  end

  private

  def frame=(frame)
    @frame = frame
  end
end
