# frozen_string_literal: true

# Queries::User::ListPublicFrames class
class Queries::User::ListPublicFrames
  include Query

  def initialize(user_id:)
    @user_id = user_id
  end

  def execute
    user = Queries::User::FindUser.run(user_id: @user_id)
    user.frames.where(private: false).order('frames.created_at': "desc")
  end
end
