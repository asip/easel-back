# frozen_string_literal: true

# toast
module Toast
  # Component class
  class Component < ViewComponent::Base
    def initialize(flash: {})
      @json = to_json(flash:)
    end

    private

    def to_json(flash:)
      Oj.dump(flash.present? ? flash.to_h.transform_values { |value| [ value ] } : {})
    end
  end
end
