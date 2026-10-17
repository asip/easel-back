# Vesper::Model::Errors::API module
module Vesper::Model::Errors::API
  extend ActiveSupport::Concern

  def error_map
    self.errors.to_hash(false).with_indifferent_access
  end
end
