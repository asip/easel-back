# frozen_string_literal: true

# Login::Validate module
module Login::Validate
  def self.run(form:, type:)
    model = type.find_for_authentication(email: form[:email])
    if model
      self.validate_password(model:, form:)
    else
      model = type.new(form)
      self.validate_email(model:, form:)
    end
    success = model.errors.empty?
    [ success, model ]
  end

  private

  def self.validate_password(model:, form:)
    password = form[:password]
    model.password = password
    model.valid?(:login)
    errors = model.errors
    errors.add(:password, I18n.t("action.login.invalid")) if password.present? && !errors.include?(:password)
  end

  def self.validate_email(model:, form:)
    model.valid?(:login)
    errors = model.errors
    errors.delete(:email) if errors[:email].include?(I18n.t("errors.messages.taken"))
    errors.add(:email, I18n.t("action.login.invalid")) if form[:email].present? && !errors.include?(:email)
  end
end
