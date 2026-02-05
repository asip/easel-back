# frozen_string_literal: true

# toast
module Toast
  # Component class
  class Component < ViewComponent::Base
    def initialize(flash: {}, flashes: {})
      @flashes_json = flashes_to_json(flash:, flashes:)
    end

    private

    def flashes_to_json(flash:, flashes:)
      if flash.present?
        to_json(flash:)
      elsif flashes.present?
        Oj.dump(flashes)
      end
    end

    def to_json(flash:)
      flash_ = {}
      flash.each do |key, value|
        flash_[key] = [ value ]
      end
      Oj.dump(flash_)
    end
  end
end
