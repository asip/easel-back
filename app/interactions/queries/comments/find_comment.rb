# frozen_string_literal: true

# Queries::Comments::FindComment class
class Queries::Comments::FindComment
  include Query

  def initialize(user:, frame_id: nil, comment_id:)
    @user = user
    @frame_id = frame_id
    @comment_id = comment_id
  end

  def execute
    user_id = @user.id
    if @frame_id.present?
      Comment.find_by!(user_id:, frame_id: @frame_id, id: @comment_id)
    else
      Comment.find_by!(user_id:, id: @comment_id)
    end
  end
end
