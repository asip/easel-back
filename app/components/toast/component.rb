# frozen_string_literal: true

# toast
module Toast
  # Component
  class Component < ViewComponent::Base
    def initialize(flash: {}, flashes: {})
      super
      @flash = flash
      @flashes = flashes
      @flashes_json = flashes_json
    end

    private

    def flashes_json
      if @flash.present?
        flash_to_json
      elsif @flashes.present?
        @flashes.to_json
      end
    end

    def flash_to_json
      flash_ = {}
      @flash.each do |key, value|
        flash_[key] = [value]
      end
      flash_.to_json
    end
  end
end
