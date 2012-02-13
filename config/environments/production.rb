N2::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = false
  config.assets.compress = false
  config.assets.compile = false
  config.assets.digest = true
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify

  # Load up redis config info
  resque_base_file = Rails.root.to_s + '/config/resque.yml'
  resque_file = File.exists?(resque_base_file) ? resque_base_file : (resque_base_file + '.sample')
  resque_config = YAML.load_file(resque_file)['production']
  redis_host, redis_port = resque_config.split(/:/)

  # Use a different cache store in production
  app_name = Rails.root.to_s =~ %r(/([^/]+)/(current|release)) ? $1 : 'newscloud'
  config.cache_store = :redis_store, { :host => redis_host, :port => redis_port, :namespace => app_name }

end
