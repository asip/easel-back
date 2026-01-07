# frozen_string_literal: true

# UseCase module
module UseCase
  extend ActiveSupport::Concern
  include ActiveModel::Model

  # ClassMethods module
  module ClassMethods
    def run(**args)
      new(**args).tap { |use_case| use_case.valid? && use_case.execute }
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

  def raise_rollback
    raise ActiveRecord::Rollback
  end
end
