# frozen_string_literal: true

#
# ArrayType class
#
class ArrayType < ActiveModel::Type::Value
  def cast(value)
    case value
    when Array then value
    when String then Oj.load(value) # value.split(",").map(&:strip)
    when NilClass then []
    else Array(value)
    end
  end

  def serialize(value)
    Oj.dump(Array(value)) # Array(value).join(",")
  end
end
