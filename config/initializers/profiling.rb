# frozen_string_literal: true

if Rails.env.development?
  Rails.application.config.after_initialize do
    Bullet.enable        = true
    Bullet.alert         = false
    Bullet.bullet_logger = true
    Bullet.console       = false
    Bullet.rails_logger  = true
    Bullet.add_footer    = false
    Prosopite.enabled = true
    Prosopite.prosopite_logger = true
    Prosopite.rails_logger = true
  end
elsif Rails.env.test?
  Rails.application.config.after_initialize do
    Prosopite.rails_logger = true
    Prosopite.raise = true
  end
end
