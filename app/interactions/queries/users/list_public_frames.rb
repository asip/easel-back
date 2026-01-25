# frozen_string_literal: true

# Queries::Users::ListPublicFrames class
class Queries::Users::ListPublicFrames
  include Query

  def initialize(user_id:)
    @user_id = user_id
  end

  def execute
    User.with_discarded.find_by!(id: @user_id).frames.where(private: false).order('frames.created_at': "desc")
  end
end
