class FeedsWorker
  @queue = :feeds

  def self.perform(feed_id = nil)
    if feed_id
      feed = Feed.active.find_by_id(feed_id)
      N2::FeedParser.update_feed(Feed.active.find(feed_id), :timeout => @timeout) if feed
    else
      N2::FeedParser.update_feeds @timeout
    end
  end

  def self.set_timeout timeout
    @timeout = timeout
  end
    
end