require 'lib/jobs/workers/noqueue'

module N2
	module JobQueues

		module Noqueue

			class Job

				def self.enqueue klass, params
					klass.send(:perform, params)
				end

				def self.dequeue klass, params
				end

				def self.workers
				  N2::JobQueues::Noqueue::Workers
				end

			end

		end

	end
end
