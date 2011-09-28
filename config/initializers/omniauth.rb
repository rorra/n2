# Inspired by:
# http://blog.hulihanapplications.com/browse/view/69-autodetecting-oauth-providers-with-omniauth

config_file = File.join(Rails.root, "config", "providers.yml")
config = File.exists?(config_file) ? YAML::load_file(config_file) : nil
APP_CONFIG['omniauth'] = config

#take keys of hash and transform those to a symbols
# HACK: need this for omniauth, explodes occur with string keys for client_options
def transform_keys_to_symbols(value)
  return value if not value.is_a?(Hash)
  hash = value.inject({}){|memo,(k,v)| memo[k.to_sym] = transform_keys_to_symbols(v); memo}
  return hash
end

if config.present?
  ActionController::Dispatcher.middleware.use OmniAuth::Builder do
    config["providers"].each do |name, settings|
      options = settings["options"] || {}
      # HACK: need keys as symbols or facebook auth explodes
      options = transform_keys_to_symbols(options)
      provider name.to_sym, settings["key"], settings["secret"], options
      #provider name.to_sym, credentials["key"], credentials["secret"], {:client_options => {:ssl => {:ca_path => "/etc/ssl/certs"}}}
    end
  end
end
