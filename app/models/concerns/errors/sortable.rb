# frozen_string_literal: true

# errors
module Errors
  # Sortable module
  module Sortable
    extend ActiveSupport::Concern

    protected

    def full_error_messages_for(columns)
      full_error_messages = []
      columns.each do |column|
        next unless errors.attribute_names.include?(column)

        errors.full_messages_for(column).each do |message|
          full_error_messages << message
        end
      end
      full_error_messages
    end
  end
end
