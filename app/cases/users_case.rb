# frozen_string_literal: true

# Users Case
class UsersCase
  def create_user(form_params:)
    mutation = Mutations::Users::CreateUser.run(form_params:)

    [mutation.success?, mutation.user]
  end

  def update_user(user:, form_params:)
    mutation = Mutations::Users::UpdateUser.run(user:, form_params:)

    [mutation.success?, mutation.user]
  end

  def find_query(user_id:)
    Queries::Users::FindUser.run(user_id:)
  end

  def frames_query(user_id:)
    Queries::Users::ListFrames.run(user_id:)
  end
end
