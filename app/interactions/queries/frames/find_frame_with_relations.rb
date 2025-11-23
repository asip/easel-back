# frozen_string_literal: true

# queries
module Queries
  # frames
  module Frames
    # FindFrameWithRelations
    class FindFrameWithRelations
      include Query

      def initialize(frame_id:, private: nil, user: nil)
        @frame_id = frame_id
        @private = private
        @user = user
      end

      def execute
        if @user.blank? && @private.blank?
          Frame.eager_load(:user, comments: :user).find_by!(id: @frame_id)
        elsif @user.blank? && @private.present?
          Frame.eager_load(:user, comments: :user).find_by!(id: @frame_id, private: @private)
        elsif @user.present? && @private.blank?
          Frame.eager_load(:user, comments: :user)
          .merge(
            Frame.where(user_id: @user.id).or(
              Frame.where(private: false).where.not(user_id: @user.id)
            )
          ).find_by!(id: @frame_id)
        end
      end
    end
  end
end
