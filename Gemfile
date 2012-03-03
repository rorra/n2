source :gemcutter

gem "rails", "3.1.3"
gem 'json'
gem 'jquery-rails'

gem "acts_as_tree"
gem "sprockets"
gem 'haml'
gem "sass-rails"
gem 'compass', :git => 'git://github.com/chriseppstein/compass.git', :ref => "8c84869b0b6bc5396e264fea15c71d4e346ac5d0"
gem 'compass-960-plugin'
gem 'mogli', :git => 'git://github.com/adahmash/mogli.git'
gem "thumbs_up"
gem "prototype-rails"

gem "formtastic", :git => "git://github.com/joevandyk/formtastic.git", :ref => "90e58f7"
gem "friendly_id", '3.3.1'
gem 'will_paginate'
gem "oauth-plugin", ">= 0.4.0.pre1"
gem "twitter", :git => "https://github.com/jnunemaker/twitter.git"
gem "mysql2"
gem "bitly"
gem "redis"
gem "redis-namespace"
gem "resque", :git => 'git://github.com/defunkt/resque.git'
gem "resque-retry"
gem "resque-scheduler", :require => 'resque_scheduler'
gem 'sitemap_generator'
gem "SystemTimer"
gem "aasm"
gem "aws-s3"
gem "aws-sdk"
gem "acl9"
gem "paperclip"
gem 'amazon-ecs'
gem 'routing-filter'

# JVD: having problems getting this working with an empty database
# The gem tries to load the locales table before it exists.
# Patched this to fix issues with the Translation model
gem 'i18n_backend_database', :git => "git://github.com/chewbranca/i18n_backend_database.git"
# JVD: Use this when developing, checkout the i18n_backend_database to ../
# gem 'i18n_backend_database', :path => "../i18n_backend_database"

#gem "hoptoad_notifier"
gem "airbrake"
gem "acts-as-taggable-on"

gem 'redis-store'

# Feedzirra related
gem 'nokogiri'
gem 'loofah'
gem 'feedzirra', :git => 'https://github.com/pauldix/feedzirra.git'
#gem 'curb', :git => 'git://github.com/taf2/curb.git'
#gem 'sax-machine', :git => 'git://github.com/pauldix/sax-machine.git'

gem "omniauth", '1.0.1'
gem "omniauth-facebook", :git => "git://github.com/mkdynamic/omniauth-facebook.git"
gem "omniauth-twitter"


group :development do
  gem "rails-dev-tweaks"
  gem "wirble"
  gem "awesome_print"
	gem "capistrano"
	gem "capistrano-ext"
end

group :development, :test do
	gem "rspec"
	gem "rspec-rails"
end

group :test, :cucumber do
	gem "database_cleaner", '0.7.0'
	gem "capybara", '1.1.2'
	gem "cucumber"
	gem "cucumber-rails"
	gem "factory_girl"
	gem "rcov"
	gem "pickle"
	gem "launchy"
	gem "ZenTest", "4.5.0"
	gem "rr"
end

group :production do
  gem "passenger"
  gem "newrelic_rpm"
end

#group :assets do
  #gem 'uglifier'
#end
