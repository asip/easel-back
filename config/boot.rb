# frozen_string_literal: true

# ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)
unless ENV['BUNDLE_GEMFILE'] && File.exist?(ENV['BUNDLE_GEMFILE'])
  ENV['BUNDLE_GEMFILE'] = File.expand_path('../gems.rb', __dir__)
end
ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', __dir__) unless File.exist?(ENV['BUNDLE_GEMFILE'])

require 'bundler/setup' # Set up gems listed in the Gemfile.
