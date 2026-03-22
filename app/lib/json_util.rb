# frozen_string_literal: true

# JsonUtil class
class JsonUtil
  def self.to_hash(str)
    (str.present? ? Oj.load(str) : {}).with_indifferent_access
  end
end
