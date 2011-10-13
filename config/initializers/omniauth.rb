# Thanks to: http://stackoverflow.com/questions/5518101/switching-between-web-and-touch-interfaces-on-facebook-login-using-omniauth-and-r
module OmniAuth
  module Strategies
    class Facebook < OAuth2

      MOBILE_USER_AGENTS =  'webos|ipod|iphone|mobile'

      def request_phase
        options[:scope] ||= "email,offline_access"
        options[:display] = mobile_request? ? 'touch' : 'page'
        super
      end

      def mobile_request?
        ua = Rack::Request.new(@env).user_agent.to_s
        ua.downcase =~ Regexp.new(MOBILE_USER_AGENTS)
      end

    end
  end
end


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
