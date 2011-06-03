class JobsController < ApplicationController
  def run
    Rails.logger.debug "Initializing job request"
    job = Newscloud::Redcloud.q_pop 'asdf'
    #worker = Resque::Worker.new '*'
    #worker.work 0
    #render :text => "Finished up" and return
    timeout = 10
    begin
      if FeedsWorker.respond_to? :set_timeout
        FeedsWorker.set_timeout timeout
      end
      FeedsWorker.perform
    rescue Newscloud::Redcloud::JobTimeoutError => error
      #Newscloud::Redcloud.q_push 'asdf', job
      Rails.logger.debug "***Job not completed in time.. requeuing"
      render :text => "Job paused for later processing.." and return
    end
    Rails.logger.debug "Finished processing job"
    render :text => "Processed: #{job.inspect}" and return
  end
end
