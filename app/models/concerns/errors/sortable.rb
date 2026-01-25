# frozen_string_literal: true

# Errors::Sortable module
module Errors::Sortable
  extend ActiveSupport::Concern

  protected

  def full_error_messages_for(columns)
    columns.each_with_object([]) do |column, messages|
      messages.concat(errors.full_messages_for(column))
    end
  end
end
