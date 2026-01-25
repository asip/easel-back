# frozen_string_literal: true

# DateAndTime::Util class
class DateAndTime::Util
  def self.valid_date?(str)
    !!Date.parse(str)
  rescue StandardError
    false
  end
end
