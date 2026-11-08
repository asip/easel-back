# frozen_string_literal: true

# Api Controller
class Api::V1::AppController < Vesper::Api::Controller
  include Jwt::Refresh
  include Locale::Detect
  include NPlusOne::Query::Detection unless Rails.env.production?
  include Account::Authentication
end
