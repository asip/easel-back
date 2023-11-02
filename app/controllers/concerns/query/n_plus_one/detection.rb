# frozen_string_literal: true

# Query module
module Query
  # NPlusOne module
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
