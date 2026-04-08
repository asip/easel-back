# frozen_string_literal: true

# frame api controller
class Api::V1::FramesController < Api::V1::ApiController
  include ::Frames::Queries::Pagination
  include Frames::Authentication::Skip
  include Frames::Locale::Detect::Skip
  include Frames::Variables

  def index
    if form.valid?
      pagination, frames = list_frames(user: current_user, form:, page:)

      render_frames(frames:, pagination:)
    else
      render_errors(resource: form)
    end
  end

  def authenticated_index
    index
  end

  def show
    render_frame(frame: public_frame.with_relations)
  end

  def authenticated
    render_frame(frame: authenticated_frame.with_relations)
  end

  def comments
    render_comments(comments: comment_list)
  end

  def create
    mutation = Mutations::Frame::CreateFrame.run(user: current_user, form: form_params)
    frame = mutation.frame

    if mutation.success?
      render_frame(frame:)
    else
      render_errors(resource: frame)
    end
  end

  def update
    mutation = Mutations::Frame::UpdateFrame.run(frame: account_frame, form: form_params)
    frame = mutation.frame

    if mutation.success?
      render_frame(frame:)
    else
      render_errors(resource: frame)
    end
  end

  def destroy
    mutation = Mutations::Frame::DeleteFrame.run(frame: account_frame)
    frame = mutation.frame
    render_frame(frame:)
  end

  private

  def frame
    Queries::Frame::FindFrame.run(frame_id: id, user: current_user)
  end

  def public_frame
    Queries::Frame::FindFrame.run(frame_id: id, private: false)
  end

  def authenticated_frame
    Queries::Frame::FindFrame.run(frame_id:, user: current_user)
  end

  def account_frame
    Queries::Frame::FindFrame.run(frame_id: id, user: current_user, authenticated: true)
  end

  def comment_list
    Queries::Frame::ListCommentsWithUser.run(frame_id:)
  end
end
