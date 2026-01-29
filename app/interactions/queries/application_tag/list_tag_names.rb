# frozen_string_literal: true

# Queries::ApplicationTag::ListTagNames class
class Queries::ApplicationTag::ListTagNames
  include Query

  def initialize(name:)
    @name = name
  end

  def execute
    ApplicationTag.search_by(name: @name).order(name: :asc).limit(5)
  end
end
