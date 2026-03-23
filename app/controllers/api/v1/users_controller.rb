# frozen_string_literal: true

# user api controller
class Api::V1::UsersController < Api::V1::ApiController
  include ::Users::Queries::Pagination
  include Account::Authentication::Skip

  def show
    render_user(user:)
  end

  def frames
    pagination, frames = list_frames(user_id: route_params[:id], page: route_params[:page])

    render_frames(frames:, pagination:)
  end

  private

  def user
    Queries::User::FindUser.run(user_id: route_params[:id])
  end

  def route_params
    @route_params ||= params.permit(:id, :page).to_h
  end
end
