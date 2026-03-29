# frozen_string_literal: true

# Flashes module
module Flashes
  extend ActiveSupport::Concern

  included do
    helper_method :flashes
  end

  protected

  def flashes
    @flashes ||= {}
  end
end
