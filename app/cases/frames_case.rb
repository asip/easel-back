# frozen_string_literal: true

# Frames Case
class FramesCase
  def create_frame(user:, form_params:)
    mutation = Mutations::Frames::CreateFrame.run(user:, form_params:)

    [mutation.success?, mutation.frame]
  end

  def update_frame(user:, frame_id:, form_params:)
    mutation = Mutations::Frames::UpdateFrame.run(user:, frame_id:, form_params:)

    [mutation.success?, mutation.frame]
  end

  def delete_frame(user:, frame_id:)
    mutation = Mutations::Frames::DeleteFrame.run(user:, frame_id:)
    mutation.frame
  end

  def list_query(word:)
    Queries::Frames::ListFrames.run(word:)
  end

  def find_query_with_relations(frame_id:)
    Queries::Frames::FindFrameWithRelations.run(frame_id:)
  end

  def comments_query_with_user(frame_id:)
    Queries::Frames::ListCommentsWithUser.run(frame_id:)
  end
end
