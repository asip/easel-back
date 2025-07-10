# frozen_string_literal: true

# Flashes module
module Flashes
  extend ActiveSupport::Concern

  included do
    attr_reader :flashes

    before_action :init_flashes
  end

  protected

  def init_flashes
    @flashes = {}
  end
end
