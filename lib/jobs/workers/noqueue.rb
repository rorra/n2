module N2
	module JobQueues

		module Noqueue
			module Workers

				module RakeJob
					@queue = :rake_tasks

					def self.perform(command)
						# TODO:: make this work with params
						Rake::Task[command].invoke
					end
				end

				module ImageJob
					@queue = :image_processing

					def self.perform(url, pid = nil, socket = nil)
						# bump unicorn worker count if pid
						# curl url to socket if socket
						# drop unicorn worker count if pid
					end
				end

			end
		end

	end
end
