# frozen_string_literal: true

# display
module Display
  # messages
  module Messages
    # Component class
    class Component < ViewComponent::Base
      def initialize(model:, attr:)
        @messages = model.error_sym_map[attr]
      end
    end
  end
end
