# frozen_string_literal: true

# user api controller
class Api::V1::UsersController < Api::V1::ApiController
  include ::Users::Queries::Pagination
  include Account::Authentication::Skip
  include ::Users::Variables

  def show
    render_user(user)
  end

  def frames
    pagy, frames = list_frames(user_id:, page:)

    render_frames(frames, pagy:)
  end

  private

  def user
    Queries::User::FindUser.run(user_id:)
  end
end
