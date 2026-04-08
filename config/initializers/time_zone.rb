# frozen_string_literal: true

# timezone
time_zone = ENV.fetch("TIME_ZONE") { "Asia/Tokyo" }
time_zone_db = ENV.fetch("TIME_ZONE_DB") { "Asia/Tokyo" }

Rails.application.config do |config|
  config.time_zone = time_zone
  if time_zone_db == time_zone
    config.active_record.default_timezone = :local
  else
    config.active_record.default_timezone = :utc
  end
end
