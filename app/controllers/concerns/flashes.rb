# frozen_string_literal: true

# Flashes module
module Flashes
  extend ActiveSupport::Concern

  included do
    helper_method :flashes

    before_action :init_flashes
  end

  protected

  def flashes
    @flashes
  end

  def init_flashes
    @flashes = {}
  end
end
