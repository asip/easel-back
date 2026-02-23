# frozen_string_literal: true

# session api controller
class Api::V1::SessionsController < Api::V1::ApiController
  include ActionController::Cookies
  include ::Sessions::Queries::Pagination

  # def show
  #   render json: {}, status: :ok
  # end

  def profile
    user = current_user

    # response.set_header("Authorization", "Bearer #{user.token}")
    render_account(account: user)
  end

  def frames
    pagination, frames = list_frames(user: current_user, page: query_params[:page])

    render_frames(frames:, pagination:)
  end

  private

  def query_params
    @query_params ||= params.permit(:page).to_h
  end
end
