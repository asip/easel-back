# frozen_string_literal: true

# display
module Display
  # messages
  module Messages
    # collection
    module Collection
      # Component class
      class Component < ViewComponent::Base
        with_collection_parameter :message

        def initialize(message:)
          @message = message
        end
      end
    end
  end
end
