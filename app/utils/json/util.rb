# frozen_string_literal: true

# Json::Util class
class Json::Util
  def self.to_hash(str)
    (str.present? ? Oj.load(str) : {}).with_indifferent_access
  end
end
