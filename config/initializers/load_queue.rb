queue = APP_CONFIG['jobqueue'] || 'noqueue'

if queue and File.exists?("#{RAILS_ROOT}/lib/jobs/#{queue.downcase}.rb")
	require "#{RAILS_ROOT}/lib/jobs/#{queue.downcase}"

	jobqueue = N2::JobQueues.const_get(queue.camelize).const_get('Job')

	Rails.class_eval do
	  @@jobqueue = nil
	  #cattr_reader :jobqueue
	  class << self; attr_accessor :jobqueue; end

	  #def self.jobqueue=(jobqueue)
	    #@@jobqueue = jobqueue
	  #end
	end

	Rails.jobqueue = jobqueue
end
