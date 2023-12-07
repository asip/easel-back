# frozen_string_literal: true

# Comments Case
class CommentsCase
  def create_comment(user:, frame_id:, form_params:)
    mutation = Mutations::Comments::CreateComment.run(user:, frame_id:, form_params:)

    [mutation.success?, mutation.comment]
  end

  def delete_comment(user:, comment_id:)
    mutation = Mutations::Comments::DeleteComment.run(user:, comment_id:)
    mutation.comment
  end
end
