# frozen_string_literal: true

# Admin::Authentication module
module Admin::Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_admin!
  end
end
