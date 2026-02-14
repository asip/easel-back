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
    model.password = @form[:password]
    errors = valid_model
    add_error(errors:, attr: :password)
  end

  def validate_email
    errors = valid_model
    errors.delete(:email) if errors[:email].include?(I18n.t("errors.messages.taken"))
    add_error(errors:, attr: :email)
  end

  def valid_model
    model.valid?(:login)
    model.errors
  end

  def add_error(errors:, attr:)
    errors.add(attr, I18n.t("action.login.invalid")) if @form[attr].present? && !errors.include?(attr)
  end
end
