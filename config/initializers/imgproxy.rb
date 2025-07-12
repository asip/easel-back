require "imgproxy"

Imgproxy.configure do |config|
  # Full URL to where your imgproxy lives.
  config.endpoint = ENV.fetch("IMGPROXY_ENDPOINT")
  config.use_s3_urls = ENV.fetch("IMGPROXY_USE_S3_URLS")
  config.shrine_host = ENV.fetch("IMGPROXY_SHRINE_HOST")
  # Hex-encoded signature key and salt
  config.key = ENV.fetch("IMGPROXY_KEY") { nil }
  config.salt = ENV.fetch("IMGPROXY_SALT") { nil }
end

Imgproxy.extend_shrine!
