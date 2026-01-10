require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Master key
  # config.require_master_key = true

  # Static files
  # config.public_file_server.enabled = false

  # Asset compression
  # config.assets.css_compressor = :sass
  config.assets.compile = false

  # Asset host
  # config.asset_host = "http://assets.example.com"

  # Send files header
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Active Storage
  config.active_storage.service = :amazon

  # Action Cable
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]

  # Force SSL
  config.force_ssl = true

  # Logging
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
  config.log_tags = [:request_id]

  valid_levels = [:debug, :info, :warn, :error, :fatal, :unknown]
  level = (ENV.fetch("RAILS_LOG_LEVEL", "info").downcase.to_sym rescue :info)
  level = :info unless valid_levels.include?(level)

  # Cache store
  # config.cache_store = :mem_cache_store

  # Active Job
  # config.active_job.queue_adapter = :resque
  # config.active_job.queue_name_prefix = "medical_record_app_production"

  # Action Mailer
  config.action_mailer.perform_caching = false

  # URL options
  config.action_mailer.default_url_options = {
    host: "kodomo-karute.jp",
    protocol: "https"
  }

  # SMTP settings for Gmail via Render ENV variables
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              ENV["SMTP_ADDRESS"],
    port:                 ENV["SMTP_PORT"].to_i,
    domain:               "gmail.com",
    user_name:            ENV["SMTP_USERNAME"],
    password:             ENV["SMTP_PASSWORD"],
    authentication:       :plain,
    enable_starttls_auto: true
  }

  config.action_mailer.default_options = {
    from: ENV["MAIL_FROM"]
  }

  # I18n
  config.i18n.fallbacks = true

  # Deprecations
  config.active_support.report_deprecations = false

  # Schema dump
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [:id]

  # DNS/Host protection
  # config.hosts = [...]
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end
