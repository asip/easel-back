# frozen_string_literal: true

# account/authentication/Skip module
module Account::Authentication::Skip
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_user!
  end
end
