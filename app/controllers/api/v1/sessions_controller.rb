# frozen_string_literal: true

# session api controller
class Api::V1::SessionsController < Api::V1::ApiController
  include ActionController::Cookies
  include ::Sessions::Queries::Pagination
  include ::Sessions::Variables

  # def show
  #   render json: {}, status: :ok
  # end

  def profile
    render_account(account: current_user)
  end

  def frames
    pagination, frames = list_frames(user: current_user, page:)

    render_frames(frames:, pagination:)
  end
end
