# frozen_string_literal: true

# errors
module Errors
  # message
  module Message
    # Component class
    class Component < ViewComponent::Base
      def initialize(model:, attr_name:)
        @model = model
        @attr_name = attr_name
      end
    end
  end
end
