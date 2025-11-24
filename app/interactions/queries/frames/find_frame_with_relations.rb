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
        scope = Frame.eager_load(:user, comments: :user)
        if @user.blank? && @private.blank?
          scope.find_by!(id: @frame_id)
        elsif @user.blank? && @private.present?
          scope.find_by!(id: @frame_id, private: @private)
        elsif @user.present? && @private.blank?
          scope.eager_load(:user, comments: :user)
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
