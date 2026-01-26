# frozen_string_literal: true

# Queries::Frame::FindFrame class
class Queries::Frame::FindFrame
  include Query

  def initialize(frame_id:, private: nil, user: nil)
    @frame_id = frame_id
    @private = private
    @user = user
  end

  def execute
    private_nil = @private.nil?
    scope = Frame
    if @user.blank?
      if private_nil
        scope.find_by!(id: @frame_id)
      else
        scope.find_by!(id: @frame_id, private: @private)
      end
    elsif private_nil
      user_id = @user.id
      scope.eager_load(:user, comments: :user)
           .merge(
            Frame.where(user_id:).or(
              Frame.where(private: false).where.not(user_id:)
            )
           ).find_by!(id: @frame_id)
    end
  end
end
