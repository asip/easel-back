# frozen_string_literal: true

# display
module Display
  # messages
  module Messages
    # item
    module Item
      # Component class
      class Component < ViewComponent::Base
        def initialize(message:)
          @message = message
        end
      end
    end
  end
end
