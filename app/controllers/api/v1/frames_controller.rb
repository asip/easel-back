# frozen_string_literal: true

# frame api controller
class Api::V1::FramesController < Api::V1::ApiController
  include ::Frames::Queries::Pagination
  include Frames::Authentication::Skip
  include Frames::Locale::Detect::Skip

  def index
    items = JsonUtil.to_hash(criteria)
    form = FrameSearchForm.new(items)
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
    render_frame(frame: public_frame_with_relations)
  end

  def authenticated
    render_frame(frame: frame_with_relations)
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
    mutation = Mutations::Frame::UpdateFrame.run(frame:, form: form_params)
    frame = mutation.frame

    if mutation.success?
      render_frame(frame:)
    else
      render_errors(resource: frame)
    end
  end

  def destroy
    mutation = Mutations::Frame::DeleteFrame.run(frame:)
    frame = mutation.frame
    render_frame(frame:)
  end

  private

  def frame
    Queries::Frame::FindFrame.run(user: current_user, frame_id: id)
  end

  def public_frame_with_relations
    Queries::Frame::FindFrameWithRelations.run(frame_id: id, private: false)
  end

  def frame_with_relations
    Queries::Frame::FindFrameWithRelations.run(frame_id:, user: current_user)
  end

  def comment_list
    Queries::Frame::ListCommentsWithUser.run(frame_id:)
  end

  def query_params
    @query_params ||= params.permit(:q, :page).to_h
  end

  def page
    query_params[:page]
  end

  def criteria
    query_params[:q]
  end

  def path_params
    @path_params ||= params.permit(:id, :frame_id).to_h
  end

  def id
    path_params[:id]
  end

  def frame_id
    path_params[:frame_id]
  end

  def form_params
    @form_params ||= params.expect(
      frame: [ :name, :tag_list, :comment, :file, :creator_name, :shooted_at, :private ]
    ).to_h
  end
end
