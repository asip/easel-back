# frozen_string_literal: true

if Rails.env.development?
  Rails.application.config.hosts << "easel_api:3000"
end
