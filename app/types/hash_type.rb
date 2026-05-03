# frozen_string_literal: true

#
# HashType class
#
class HashType < ActiveModel::Type::Value
  def cast(value)
    case value
    when Hash then value
    when String then Oj.load(value)
    when NilClass then {}
    else Hash(value)
    end
  end

  def serialize(value)
    Oj.dump(Hash(value)) # Array(value).join(",")
  end
end
