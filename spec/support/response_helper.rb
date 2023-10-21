# frozen_string_literal: true

module ResponseHelpers
  def json
    ActiveSupport::HashWithIndifferentAccess.new(JSON.parse(response.body, symbolize_names: true))
  end
end

RSpec.configure do |config|
  config.include ResponseHelpers, type: :request
end
