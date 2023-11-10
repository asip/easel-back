# frozen_string_literal: true

# Comments Case
class CommentsCase
  def create_comment(user:, frame_id:, form_params:)
    comment = Comment.new(form_params)
    save_comment(user:, frame_id:, comment:)
  end

  def delete_comment(user:, comment_id:)
    comment = Comment.find_by!(id: comment_id, user_id: user.id)
    comment.destroy
    comment
  end

  private

  def save_comment(user:, frame_id:, comment:)
    comment.frame_id = frame_id
    comment.user_id = user.id
    success = comment.save
    [success, comment]
  end
end
