N2::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin
  config.serve_static_assets = false
  config.assets.compress = false
  config.assets.compile = true
  config.assets.debug = true

  config.dev_tweaks.autoload_rules do
    keep :all

    skip '/favicon.ico'
    skip :assets
    skip :xhr
    keep :forced
  end

end
