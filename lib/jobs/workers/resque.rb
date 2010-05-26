require 'open3'

module N2
	module JobQueues

		module Resque
			module Workers

				module RakeJob
					@queue = :rake_tasks

					def self.perform(path, command)
						Open3.popen(%{cd #{path} && #{command}}) do |stdin, stdout, stderr|
							raise stderr and return if stderr
							puts stdout.get
						end
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
