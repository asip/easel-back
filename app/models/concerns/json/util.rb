# frozen_string_literal: true

# Date and Time Module
module Json
  # Utility Module
  module Util
    extend ActiveSupport::Concern

    # Instance Methods
    def errors_to_json
      {
        messages: errors.full_messages
      }.to_json
    end
  end
end
