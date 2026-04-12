# frozen_string_literal: true

if Rails.env.development?
  Rails.application.config.logger = Logger.new("log/development.log", 10, 5 * 1024 * 1024)
elsif Rails.env.test?
  Rails.application.config.logger = Logger.new("log/test.log", 10, 5 * 1024 * 1024)
end
