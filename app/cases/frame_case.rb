# frozen_string_literal: true

# Frame Case
class FrameCase
  def create_frame(user:, frame_params:)
    frame = Frame.new(frame_params)
    frame.user_id = user.id
    result = frame.save
    [result, frame]
  end

  def update_frame(user:, frame_id:, frame_params:)
    frame = Frame.find_by!(id: frame_id, user_id: user.id)
    frame.user_id = user.id
    frame.attributes = frame_params
    result = frame.save
    [result, frame]
  end

  def delete_frame(user:, frame_id:)
    frame = Frame.find_by!(id: frame_id, user_id: user.id)
    frame.destroy
    frame
  end

  def list_query(word:)
    Frame.search_by(word:).order(created_at: 'desc')
  end

  def detail_query(frame_id:)
    Frame.eager_load(:user, comments: :user).find_by!(id: frame_id)
  end

  def comments_query(frame_id:)
    frame = Frame.find_by!(id: frame_id)
    Comment.eager_load(:user).where(frame_id: frame.id)
           .order(created_at: 'asc')
  end
end
