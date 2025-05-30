require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Easel
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.{rb,yml}").to_s]

    # generate .js instead of .coffee
    config.generators.javascript_engine = :js

    config.action_view.form_with_generates_remote_forms = false

    # timezone
    config.active_record.default_timezone = :local
    config.time_zone = ENV.fetch("TIME_ZONE") { "Asia/Tokyo" }

    # config.action_controller.forgery_protection_origin_check = false

    config.middleware.use ActionDispatch::Flash
    config.middleware.use Rack::Locale
  end
end
