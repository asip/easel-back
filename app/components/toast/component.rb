# frozen_string_literal: true

# toast
module Toast
  # Component
  class Component < ViewComponent::Base
    def initialize(messages:)
      super
      @messages = messages
      @messages_json = {
        messages:
      }.to_json
    end
  end
end
