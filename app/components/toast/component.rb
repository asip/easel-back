# frozen_string_literal: true

# toast
module Toast
  # Component class
  class Component < ViewComponent::Base
    def initialize(flash: {}, flashes: {})
      @json = to_json(flash:, flashes:)
    end

    private

    def to_json(flash:, flashes:)
      if flash.present?
        Oj.dump(flash.to_h.transform_values { |value| [ value ] })
      elsif flashes.present?
        Oj.dump(flashes)
      end
    end
  end
end
