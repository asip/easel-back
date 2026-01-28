# frozen_string_literal: true

# Validations::ValidateAccount class
class Validations::ValidateAccount
  include Query

  def initialize(form:, type:)
    @form = form
    @type = type
  end

  def execute
    self.model = @type.find_for_authentication(email: @form[:email])
    if model
      validate_password
    else
      self.model = @type.new(@form)
      validate_email
    end
    success = model.errors.empty?
    [ success, model ]
  end

  private

  attr_accessor :model

  def validate_password
    password = @form[:password]
    model.password = password
    model.valid?(:login)
    errors = model.errors
    errors.add(:password, I18n.t("action.login.invalid")) if password.present? && !errors.include?(:password)
  end

  def validate_email
    model.valid?(:login)
    errors = model.errors
    errors.delete(:email) if errors[:email].include?(I18n.t("errors.messages.taken"))
    errors.add(:email, I18n.t("action.login.invalid")) if @form[:email].present? && !errors.include?(:email)
  end
end
