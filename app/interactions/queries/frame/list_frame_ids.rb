# frozen_string_literal: true

# Queries::Frame::ListFrameIds class
class Queries::Frame::ListFrameIds
  include Query

  def initialize(user:, form:)
    @user = user
    @form = form
  end

  def execute
    Frame.select(:id).filter_by(user: @user, form: @form).order(created_at: :desc)
  end
end
