# Load in the application settings
# Note:: this file is named 001_... to be explicitly loaded prior to all other initializers

app_settings_file = "#{Rails.root}/config/application_settings.yml"

APP_CONFIG = ActiveSupport::HashWithIndifferentAccess.new(YAML.load_file(app_settings_file)[Rails.env])
APP_CONFIG['use_view_objects'] = true unless APP_CONFIG.keys.include? "use_view_objects"
ActionMailer::Base.default_url_options[:host] = 'http://test.com' # APP_CONFIG['base_site_url'].sub(/^https?:\/\//,'')

Time.zone = APP_CONFIG['time_zone'] || 'Pacific Time (US & Canada)'

config_file = File.join(Rails.root, "config", "providers.yml")
config = File.exists?(config_file) ? YAML::load_file(config_file) : nil
APP_CONFIG[:omniauth] = config

if APP_CONFIG[:omniauth].present?
  APP_CONFIG[:omniauth][:providers].each do |provider_name, settings|
    N2::Application.config.middleware.use(OmniAuth::Builder) do
      provider_arguments = [provider_name.to_sym, settings[:key], settings[:secret]]

      if settings[:options].present?
        provider_arguments << settings[:options]
      end

      provider(*provider_arguments)
    end
  end

  # HACK:: manually specify full_host for passenger standalone
  # Cannot use passenger_set_cgi_param SERVER_HOST with standalone
  OmniAuth.config.full_host = APP_CONFIG['base_site_url'] if APP_CONFIG['base_site_url']
  
end


# Use Bit.ly version 3 API
if defined?(Bitly)
  Bitly.use_api_version_3
end
