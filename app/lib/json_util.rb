# frozen_string_literal: true

# JsonUtil class
class JsonUtil
  def self.parse(str)
    (str.present? ? Oj.load(str) : {}).with_indifferent_access
  end

  def self.stringify(hash)
    Oj.dump(hash)
  end
end
