require 'lib/jobs/noqueue'

namespace :n2 do
  namespace :jobs do
    desc "Run job"
    task :run do
      @queue = N2::JobQueues::Noqueue::Job

      @queue.enqueue @queue.workers::RakeJob, 'n2:jobs:test'
    end

    task :test do
      puts "test rake task!!"
    end
  end
end
