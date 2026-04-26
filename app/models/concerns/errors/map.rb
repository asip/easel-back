# Errors::Map module
module Errors::Map
  extend ActiveSupport::Concern

  def error_map
    self.errors.to_hash(false)
  end

  def error_sym_map
    self.error_map.with_indifferent_access
  end
end
