# frozen_string_literal: true

# user api controller
class Api::V1::UsersController < Api::V1::ApiController
  include ::Users::Queries::Pagination
  include Account::Authentication::Skip

  def show
    user = Queries::User::FindUser.run(user_id: params[:id])
    render_user(user:)
  end

  def frames
    pagination, frames = list_frames(user_id: query_params[:user_id], page: query_params[:page])

    render_frames(frames:, pagination:)
  end

  private

  def query_params
    @query_params ||= params.permit(:user_id, :page).to_h
  end
end
