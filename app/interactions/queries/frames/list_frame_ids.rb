# frozen_string_literal: true

# Queries::Frames::ListFrameIds class
class Queries::Frames::ListFrameIds
  include Query

  def initialize(user:, form:)
    @user = user
    @form = form
  end

  def execute
    Frame.select(:id).search_by(user: @user, form: @form).order(created_at: :desc)
  end
end
