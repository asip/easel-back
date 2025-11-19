# frozen_string_literal: true

# Date Validator
class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    begin
      Date.parse(value.to_s)
    rescue
      record.errors.add(attribute, options[:message] || I18n.t("validations.message.model.date.invalid"))
    end
  end
end
