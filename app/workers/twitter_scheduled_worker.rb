class TwitterScheduledWorker
  @queue = :twitter_scheduled

  def self.perform
    begin
      Newscloud::Tweeter.new.tweet_hot_items
    rescue Newscloud::TweeterDisabled => e
      Rails.logger.info("ERROR:: TwitterScheduledWorker failed with: #{e.inspect}")
    end
  end

end
