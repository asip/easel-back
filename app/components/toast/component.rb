# frozen_string_literal: true

# toast
module Toast
  # Component
  class Component < ViewComponent::Base
    def initialize(flash: {}, flashes: {})
      @flashes_json = flashes_json(flash:, flashes:)
    end

    private

    def flashes_json(flash:, flashes:)
      if flash.present?
        to_json(flash:)
      elsif flashes.present?
        flashes.to_json
      end
    end

    def to_json(flash:)
      flash_ = {}
      flash.each do |key, value|
        flash_[key] = [ value ]
      end
      flash_.to_json
    end
  end
end
