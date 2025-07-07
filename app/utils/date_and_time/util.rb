# frozen_string_literal: true

# date and time
module DateAndTime
  # Utility module
  class Util
    def self.valid_date?(str)
      !!Date.parse(str)
    rescue StandardError
      false
    end
  end
end
