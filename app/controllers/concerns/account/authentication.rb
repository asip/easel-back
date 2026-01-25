# frozen_string_literal: true

# Account::Authentication module
module Account::Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end
end
