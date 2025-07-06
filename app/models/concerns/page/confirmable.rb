# frozen_string_literal: true

# page
module Page
  # Confirmable module
  module Confirmable
    extend ActiveSupport::Concern

    included do
      attr_reader :confirming

      validates :confirming, acceptance: true

      after_validation :check_confirming
    end

    protected

    def check_confirming
      errors.delete(:confirming)
      @confirming = errors.empty? ? "true" : ""
    end
  end
end
