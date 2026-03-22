# frozen_string_literal: true

# DateUtil class
class DateUtil
  def self.valid?(str)
    !!Date.parse(str)
  rescue StandardError
    false
  end
end
