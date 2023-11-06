# frozen_string_literal: true

# toast
module Toast
  # Component
  class Component < ViewComponent::Base
    def initialize(flashes:)
      super
      @flashes = flashes
      @flashes_json = flashes.to_json
    end
  end
end
