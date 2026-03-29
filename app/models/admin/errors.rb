# frozen_string_literal: true

# Admin::Errors module
module Admin::Errors
  extend ActiveSupport::Concern
  include ::Errors::Sortable
  include ::Login::Errors
end
