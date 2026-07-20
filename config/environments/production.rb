require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.assets.compile = false
  config.force_ssl = true

  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [ :id ]

  # ==> Active Storage — cloud provider
  #
  # ACTIVE_STORAGE_SERVICE controls which storage.yml service is used.
  # Set this environment variable on your hosting platform to one of:
  #   amazon        → AWS S3
  #   google        → Google Cloud Storage
  #   cloudflare_r2 → Cloudflare R2 (S3-compatible, no egress fees)
  #
  # Example (Heroku):
  #   heroku config:set ACTIVE_STORAGE_SERVICE=amazon
  #
  # Falls back to :local if the variable is not set — this will log a
  # warning at boot so the misconfiguration is immediately visible.
  storage_service = ENV.fetch("ACTIVE_STORAGE_SERVICE", "local").to_sym

  if storage_service == :local
    config.logger.warn(
      "[TheContentHub] WARNING: ACTIVE_STORAGE_SERVICE is not set. " \
      "Using local disk storage in production — uploaded files will be " \
      "lost on restart. Set ACTIVE_STORAGE_SERVICE to amazon, google, " \
      "or cloudflare_r2."
    )
  end

  config.active_storage.service = storage_service

  # ==> Mailer configuration for production
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = {
    host: ENV.fetch("APP_HOST", "localhost"),
    protocol: "https"
  }
  config.action_mailer.smtp_settings = {
    address:              ENV.fetch("SMTP_ADDRESS", "smtp.example.com"),
    port:                 ENV.fetch("SMTP_PORT", 587).to_i,
    user_name:            ENV.fetch("SMTP_USERNAME", ""),
    password:             ENV.fetch("SMTP_PASSWORD", ""),
    authentication:       :plain,
    enable_starttls_auto: true
  }
end
