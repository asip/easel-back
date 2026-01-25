# frozen_string_literal: true

# frame api controller
class Api::V1::FramesController < Api::V1::ApiController
  include ::Frames::Queries::Pagination
  include Frames::Authentication::Skip
  include Frames::Locale::Detect::Skip

  def index
    page = query_params[:page]
    items = Json::Util.to_hash(query_params[:q])
    form = FrameSearchForm.new(items)
    if form.valid?
      pagination, frames = list_frames(user: current_user, form:, page:)

      render json: Oj.load(ListItem::FrameResource.new(frames).serialize).merge(pagination)
    else
      render json: { errors: form.errors.to_hash(false) }.to_json, status: :unprocessable_content
    end
  end

  def authenticated_index
    index
  end

  def show
    frame = Queries::Frames::FindFrameWithRelations.run(frame_id: params[:id], private: false)

    render json: Detail::FrameResource.new(frame).serializable_hash
  end

  def authenticated
    frame = Queries::Frames::FindFrameWithRelations.run(frame_id: path_params[:frame_id], user: current_user)

    render json: Detail::FrameResource.new(frame).serializable_hash
  end

  def comments
    comments = Queries::Frames::ListCommentsWithUser.run(frame_id: path_params[:frame_id])

    render json: CommentResource.new(comments).serialize
  end

  def create
    mutation = Mutations::Frames::CreateFrame.run(user: current_user, form: form_params)
    frame = mutation.frame

    if mutation.success?
      render json: Detail::FrameResource.new(frame).serializable_hash
    else
      render json: { errors: frame.errors.to_hash(false) }.to_json, status: :unprocessable_content
    end
  end

  def update
    frame = Queries::Frames::FindFrame.run(user: current_user, frame_id: params[:id])

    mutation = Mutations::Frames::UpdateFrame.run(frame:, form: form_params)
    frame = mutation.frame

    if mutation.success?
      render json: Detail::FrameResource.new(frame).serializable_hash
    else
      render json: { errors: frame.errors.to_hash(false) }.to_json, status: :unprocessable_content
    end
  end

  def destroy
    frame = Queries::Frames::FindFrame.run(user: current_user, frame_id: params[:id])

    mutation = Mutations::Frames::DeleteFrame.run(frame:)
    frame = mutation.frame
    render json: Detail::FrameResource.new(frame).serializable_hash
  end

  private

  def query_params
    @query_params ||= params.permit(:q, :page).to_h
  end

  def path_params
    @path_params ||= params.permit(:frame_id).to_h
  end

  def form_params
    @form_params ||= params.expect(
      frame: [ :name, :tag_list, :comment, :file, :creator_name, :shooted_at, :private ]
    ).to_h
  end
end
