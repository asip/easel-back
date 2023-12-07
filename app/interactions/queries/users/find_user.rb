# frozen_string_literal: true

# queries
module Queries
  # users
  module Users
    # FindUser class
    class FindUser
      include Query

      def initialize(user_id:)
        @user_id = user_id
      end

      def execute
        User.find_by!(id: @user_id)
      end
    end
  end
end
