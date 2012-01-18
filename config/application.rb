require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module N2
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/lib)
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.active_record.schema_format = :sql

    config.assets.precompile << 'base.css'
    config.assets.precompile << 'grid.css'
    config.assets.precompile << 'fb_grid.css'
    config.assets.precompile << 'text.css'

    Dir[Rails.root.join('config/routes/*.rb')].each do |route_file|
      config.paths["config/routes"] << route_file
    end
  end
end
