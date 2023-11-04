# frozen_string_literal: true

# Comments Case
class CommentsCase
  def create_comment(user:, frame_id:, comment_params:)
    comment = Comment.new(comment_params)
    comment.user_id = user.id
    comment.frame_id = frame_id
    success = comment.save
    [success, comment]
  end

  def delete_comment(user:, comment_id:)
    comment = Comment.find_by!(id: comment_id, user_id: user.id)
    comment.destroy
    comment
  end
end
