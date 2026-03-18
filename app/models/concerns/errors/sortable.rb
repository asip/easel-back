# frozen_string_literal: true

# Errors::Sortable module
module Errors::Sortable
  extend ActiveSupport::Concern

  # def full_error_messages
  #   full_error_messages_for(error_properties)
  # end

  def full_error_messages_on_login
    full_error_messages_for(error_properties_on_login)
  end

  protected

  # def error_properties
  #   []
  # end

  def error_properties_on_login
    []
  end

  private

  def full_error_messages_for(columns)
    columns.each_with_object([]) do |column, messages|
      messages.concat(errors.full_messages_for(column))
    end
  end
end
