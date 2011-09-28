# Load in the application settings
# Note:: this file is named 001_... to be explicitly loaded prior to all other initializers

app_settings_file = "#{RAILS_ROOT}/config/application_settings.yml"

APP_CONFIG = YAML.load_file(app_settings_file)[RAILS_ENV]
APP_CONFIG['use_view_objects'] = true unless APP_CONFIG.keys.include? "use_view_objects"
ActionMailer::Base.default_url_options[:host] = APP_CONFIG['base_site_url'].sub(/^https?:\/\//,'')

Time.zone = APP_CONFIG['time_zone'] || 'Pacific Time (US & Canada)'

# Use Bit.ly version 3 API
if defined?(Bitly)
  Bitly.use_api_version_3
end
