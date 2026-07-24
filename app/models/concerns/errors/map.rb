# Errors::Map module
module Errors::Map
  extend ActiveSupport::Concern

  def error_map
    self.errors.to_hash(false).with_indifferent_access
  end
end
