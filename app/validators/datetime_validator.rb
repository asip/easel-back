# frozen_string_literal: true

# Datetime Validator
class DatetimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    begin
      DateTime.parse(value.to_s)
    rescue
      attribute = attribute.to_s.sub("_before_type_cast", "").to_sym
      record.errors.add(attribute, options[:message] || I18n.t("validations.message.model.datetime.invalid"))
    end
  end
end
