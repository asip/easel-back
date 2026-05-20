# frozen_string_literal: true

# Toast::Component class
class Toast::Component < ViewComponent::Base
  def initialize(flash: {})
    @json = to_json(flash:)
  end

  private

  def to_json(flash:)
    Oj.dump(flash.present? ? flash.to_h.transform_values { |value| [ value ] } : {})
  end
end
