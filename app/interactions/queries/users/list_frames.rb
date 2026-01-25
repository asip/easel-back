# frozen_string_literal: true

# Queries::Users::ListFrames class
class Queries::Users::ListFrames
  include Query

  def initialize(user:)
    @user = user
  end

  def execute
    @user.frames.order('frames.created_at': "desc")
  end
end
