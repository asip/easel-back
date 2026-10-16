# frozen_string_literal: true

# Api Controller
class Api::V1::ApiController < Vesper::Api::AppController
  include Jwt::Refresh
  include Locale::Detect
  include NPlusOne::Query::Detection unless Rails.env.production?
  include Api::Resource::Renderable
  include Account::Authentication
end
