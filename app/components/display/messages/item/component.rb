# frozen_string_literal: true

# Display::Messages::Item::Component class
class Display::Messages::Item::Component < ViewComponent::Base
  def initialize(message:)
    @message = message
  end
end
