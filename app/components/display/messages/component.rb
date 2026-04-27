# frozen_string_literal: true

# display
module Display
  # messages
  module Messages
    # Component class
    class Component < ViewComponent::Base
      def initialize(model:, attr_name:)
        @messages = model.error_sym_map[attr_name]
      end
    end
  end
end
