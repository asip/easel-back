# frozen_string_literal: true

# Error Messages
module Toast
  # Component
  class Component < ViewComponent::Base
    def initialize(messages:)
      super
      @messages = messages
      @messages_json = {
        messages: messages
      }.to_json
    end
  end
end
