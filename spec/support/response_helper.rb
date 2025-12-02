# frozen_string_literal: true

require 'oj'

module ResponseHelpers
  def json
    ActiveSupport::HashWithIndifferentAccess.new(Oj.load(response.body, symbolize_names: true))
  end
end

RSpec.configure do |config|
  config.include ResponseHelpers, type: :request
end
