# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins [ Settings.reverse_proxy.origin, Settings.origin, Settings.frontend.origin ]

    resource "*",
             headers: :any,
             methods: %i[get post put patch delete options head],
             expose: [ "Authorization", "X-CSRF-Token" ],
             credentials: true
  end
end
