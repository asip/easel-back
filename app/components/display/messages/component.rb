# frozen_string_literal: true

# Display::Messages::Component class
class Display::Messages::Component < ViewComponent::Base
  def initialize(model:, attr:)
    @messages = model.error_sym_map[attr]
  end
end
