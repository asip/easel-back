# frozen_string_literal: true

# query
module Query
  # n plus one
  module NPlusOne
    # Detection module
    module Detection
      extend ActiveSupport::Concern

      included do
        around_action :n_plus_one_detection
      end

      def n_plus_one_detection
        Prosopite.scan
        yield
      ensure
        Prosopite.finish
      end
    end
  end
end
