# frozen_string_literal: true

# Mutation module
module Mutation
  extend ActiveSupport::Concern
  include ActiveModel::Model

  # class methods
  module ClassMethods
    def run(**args)
      new(**args).tap { |mutation| mutation.valid? && mutation.execute }
    end
  end

  def execute
    raise NotImplementedError
  end

  def initialize
    raise NotImplementedError
  end

  def success?
    errors.none?
  end
end
