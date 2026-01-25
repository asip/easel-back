# frozen_string_literal: true

# user api controller
class Api::V1::UsersController < Api::V1::ApiController
  include ::Users::Queries::Pagination
  include Account::Authentication::Skip

  def show
    user = Queries::Users::FindUser.run(user_id: params[:id])
    render json: UserResource.new(user).serializable_hash
  end

  def frames
    pagination, frames = list_frames(user_id: query_params[:user_id], page: query_params[:page])

    render json: Oj.load(ListItem::FrameResource.new(frames).serialize).merge(pagination)
  end

  private

  def query_params
    @query_params ||= params.permit(:user_id, :page).to_h
  end
end
