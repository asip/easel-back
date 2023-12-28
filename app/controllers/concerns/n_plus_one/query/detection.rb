# frozen_string_literal: true

# n plus one
module NPlusOne
  # query
  module Query
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
