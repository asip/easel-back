# frozen_string_literal: true

# Queries::User::ListFrames class
class Queries::User::ListFrames
  include Query

  def initialize(user:)
    @user = user
  end

  def execute
    @user.frames.order('frames.created_at': "desc")
  end
end
