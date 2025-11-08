# frozen_string_literal: true

# admins / Application Controller
module Admins
  # Application Controller
  class ApplicationController < ActionController::Base
    include Locale::AutoDetect
    # include NPlusOne::Query::Detection unless Rails.env.production? || Rails.env.test?
    include Flashes

    protect_from_forgery with: :exception

    before_action :authenticate_admin!
  end
end
