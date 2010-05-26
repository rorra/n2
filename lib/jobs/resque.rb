require 'resque'

module N2
	module JobQueues

		module Resque
			class Job
				
				def self.enqueue klass, params
					Resque.enqueue klass, params
				end

				def self.dequeue klass, params
					Resque.dequeue klass, params
				end

			end
		end

	end
end
