# frozen_string_literal: true

# Display::Messages::Collection::Component class
class Display::Messages::Collection::Component < ViewComponent::Base
  with_collection_parameter :message

  def initialize(message:)
    @message = message
  end
end
