# frozen_string_literal: true

# toast
module Toast
  # Component
  class Component < ViewComponent::Base
    def initialize(flash: {}, flashes: {})
      super
      @flash = flash
      @flashes = flashes
      @flash_json = flash_to_json
      @flashes_json = flashes.to_json
    end

    private

    def flash_to_json
      flash_ = {}
      @flash.each do |key, value|
        flash_[key] = [value]
      end
      flash_.to_json
    end
  end
end
