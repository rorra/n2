#task "resque:setup" => :environment
# load the Rails app all the time
namespace :resque do
  puts "Loading Rails environment for Resque"
  task :setup => :environment do
    # WARNING: HERE BE STUPID RAILS HACKS!!!
    # AVERT YOUR EYES!!!
    #Rails 3 specfic
    #ActiveRecord::Base.send(:descendants).each { |klass|  klass.columns }
    # Yes... we are actually loading every model in the app..
    klasses = Dir.glob("#{RAILS_ROOT}/app/models/*.rb").map {|f| f.sub(%r{^.*/(.*?).rb$}, '\1').pluralize.classify }.map(&:constantize)
  end
end


#remove_task "resque:scheduler_setup"
task "resque:scheduler_setup" do
    puts "In custom setup with path #{ENV['load_path']}"
  path = ENV['load_path']
  load path.to_s.strip if path
end

=begin
namespace :resque do
  task :zzscheduler_setup do
    puts "In custom setup with path #{ENV['load_path']}"
    path = ENV['load_path']
    load path.to_s.strip if path
  end
end
=end
