# = Capistrano providers.yml task
# 
# Forked from::
# = Capistrano database.yml task
#
# Provides a couple of tasks for creating the database.yml 
# configuration file dynamically when deploy:setup is run.
#
# Category::    Capistrano
# Package::     Database
# Author::      Simone Carletti <weppos@weppos.net>
# Copyright::   2007-2010 The Authors
# License::     MIT License
# Link::        http://www.simonecarletti.com/
# Source::      http://gist.github.com/2769
#

unless Capistrano::Configuration.respond_to?(:instance)
  abort "This extension requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :deploy do

    namespace :config do

      desc <<-DESC
        Creates the providers.yml configuration file in shared path.
      DESC
      task :setup_providers, :except => { :no_release => true } do
        location = fetch(:template_dir, "config/deploy/templates") + '/providers.yml.erb'
        template = File.read(location)

        config = ERB.new(template)

        run "mkdir -p #{shared_path}/config" 
        put config.result(binding), "#{shared_path}/config/providers.yml"
      end

      desc <<-DESC
        [internal] Updates the symlink for providers.yml file to the just deployed release.
      DESC
      task :symlink_providers, :except => { :no_release => true } do
        run "ln -nfs #{shared_path}/config/providers.yml #{release_path}/config/providers.yml" 
      end

      desc <<-DESC
        Test file write
      DESC
      task :test_providers_write, :except => { :no_release => true } do
        location = fetch(:template_dir, "config/deploy/templates") + '/providers.yml.erb'
        template = File.file?(location) ? File.read(location) : default_template

        config = ERB.new(template)
        File.open("tmp/test_providers.yml", "w") {|f| f.write config.result(binding) }
      end

    end

    after "deploy:setup",           "deploy:config:setup_providers"   unless fetch(:skip_providers_setup, false)
    after "deploy:finalize_update", "deploy:config:symlink_providers"

  end

end
