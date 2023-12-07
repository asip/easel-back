# frozen_string_literal: true

# Query module
module Query
  extend ActiveSupport::Concern

  # class methods
  module ClassMethods
    def run(**args)
      new(**args).execute
    end
  end

  def initialize
    raise NotImplementedError
  end

  def execute
    raise NotImplementedError
  end
end
