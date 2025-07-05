require 'rspec/openapi'

# Generate multiple partial schema files, given an RSpec example
RSpec::OpenAPI.path = ->(example) {
  case example.file_path
  when %r{spec/requests/api/v1/} then 'doc/openapi/v1.yaml'
  when %r{spec/requests/api/v2/} then 'doc/openapi/v2.yaml'
  else 'doc/openapi.yaml'
  end
}

# Generate individual titles for your partial schema files, given an RSpec example
RSpec::OpenAPI.title = ->(example) {
  case example.file_path
  when %r{spec/requests/api/v1/} then 'API v1 Documentation'
  when %r{spec/requests/api/v2/} then 'API v2 Documentation'
  else 'OpenAPI Documentation'
  end
}

# Disable generating `example`
RSpec::OpenAPI.enable_example = false

# Change `info.version`
RSpec::OpenAPI.application_version = '1.0.0'
