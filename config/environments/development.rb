require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true

  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.cache_store = :memory_store
    config.public_file_server.headers = { "Cache-Control" => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.active_storage.service = :local
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_job.verbose_enqueue_logs = true
  config.assets.quiet = true
  config.action_view.annotate_rendered_view_with_filenames = true
  config.action_controller.raise_on_missing_callback_actions = true

  # ==> Mailer configuration for development
  # All emails open in the browser via Letter Opener.
  # Requires: gem "letter_opener" in the development group of your Gemfile.
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

  # ==> Bullet — N+1 query detection
  # Bullet watches every request and alerts you to:
  #   - N+1 queries (missing .includes)
  #   - Unused eager loading (unnecessary .includes)
  #   - Missing counter caches
  #
  # Alerts appear in:
  #   - The Rails log
  #   - Browser alerts (alert: true) for immediate visibility
  #   - A dedicated log file at log/bullet.log
  #
  # bullet_logger: true writes to log/bullet.log so alerts persist
  # between requests and can be reviewed after a test run.
  config.after_initialize do
    Bullet.enable        = true
    Bullet.alert         = true
    Bullet.rails_logger  = true
    Bullet.bullet_logger = true
    Bullet.add_footer    = true
  end
end
