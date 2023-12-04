# frozen_string_literal: true

Rails.application.config.session_store :redis_store,
                                       servers: ENV.fetch('REDIS_SESSION_URL', ''),
                                       expire_after: 60.minutes,
                                       key: '_easel_session'

# Rails.application.config.cache_store = :redis_cache_store,
#                                       { url: ENV.fetch('REDIS_CACHE_URL', '') }
