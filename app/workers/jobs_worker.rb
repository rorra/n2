class JobsWorker
  @queue = :jobs

  # needs to run nightly
  def self.perform()
    {:success => "Processed job"}.to_json
  end

end
