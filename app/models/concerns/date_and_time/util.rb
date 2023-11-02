# frozen_string_literal: true

# date and time
module DateAndTime
  # Utility module
  module Util
    extend ActiveSupport::Concern

    # Class Methods
    module ClassMethods
      def date_valid?(str)
        !!Date.parse(str)
      rescue StandardError
        false
      end
    end
  end
end
