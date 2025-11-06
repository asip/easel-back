# frozen_string_literal: true

# json
module Json
  # Utility module
  class Util
    def self.to_hash(str)
      (str.present? ? JSON.parse(str) : {}).with_indifferent_access
    end
  end
end
