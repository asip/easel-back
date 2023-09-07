# frozen_string_literal: true

require 'shrine'
require 'shrine/storage/s3'

s3_options = {
  access_key_id: ENV.fetch('MINIO_ACCESS_KEY', 'minioadmin'), # "AccessKey" value
  secret_access_key: ENV.fetch('MINIO_SECRET_KEY', 'minioadmin'), # "SecretKey" value
  endpoint: ENV.fetch('MINIO_ENDPOINT', ''), # "Endpoint"  value
  bucket: ENV.fetch('MINIO_BUCKET', ''), # name of the bucket you created
  region: ENV.fetch('AWS_REGION', ''),
  force_path_style: ENV.fetch('MINIO_FORCE_PATH_STYLE', true)
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options), # temporary
  store: Shrine::Storage::S3.new(prefix: 'store', **s3_options) # permanent
}

Shrine.plugin :activerecord # loads Active Record integration
Shrine.plugin :derivatives
Shrine.plugin :determine_mime_type, analyzer: :marcel
Shrine.plugin :validation
Shrine.plugin :validation_helpers
Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data # extracts metadata for assigned cached files
