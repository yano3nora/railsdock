require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    if Rails.env.development?
      config.file_watcher = ActiveSupport::FileUpdateChecker
      config.web_console.whitelisted_ips = '0.0.0.0/0'
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.time_zone = 'UTC'
    config.active_record.default_timezone = :utc
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: ENV.fetch('SMTP_HOST'),
      port: ENV.fetch('SMTP_PORT'),
      user_name: ENV.fetch('SMTP_USERNAME'),
      password: ENV.fetch('SMTP_PASSWORD'),
      authentication: ENV.fetch('SMTP_TYPE'),
      enable_starttls_auto: ENV.fetch('SMTP_TLS'),
    }
    config.action_mailer.default_url_options = {
      host: ENV.fetch('DOMAIN'),
      protocol: 'https',
    }
    config.action_controller.default_url_options = {
      host: ENV.fetch('DOMAIN'),
      protocol: 'https',
    }
  end
end
