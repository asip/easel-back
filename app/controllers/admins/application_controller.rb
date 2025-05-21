# frozen_string_literal: true

module Admins
  # Application Controller
  class ApplicationController < ActionController::Base
    include Locale::AutoDetect
    # include NPlusOne::Query::Detection unless Rails.env.production? || Rails.env.test?
    include Flashes

    protect_from_forgery with: :exception

    before_action :authenticate_admin!

    private

    protected

    def after_sign_out_path_for(resource_or_scope)
      rails_admin_path
    end
  end
end
