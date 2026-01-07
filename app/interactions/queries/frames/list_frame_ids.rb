# frozen_string_literal: true

# queries
module Queries
  # frames
  module Frames
    # ListFrameIds class
    class ListFrameIds
      include Query

      def initialize(user:, form:)
        @user = user
        @form = form
      end

      def execute
        Frame.select(:id).search_by(user: @user, form: @form).order(created_at: :desc)
      end
    end
  end
end
