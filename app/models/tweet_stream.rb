class TweetStream < ActiveRecord::Base
  acts_as_moderatable
  acts_as_taggable_on :tags, :topics

  has_many :tweets
  belongs_to :last_fetched_tweet, :class_name => 'Tweet'

  validates_presence_of :list_name, :list_username, :twitter_id_str

  before_validation :set_list_info, :unless => :twitter_id_str?

  def tweet_list
    @tweet_list ||= tweet_client.fetch_list_info(list_username, list_name)
  end

  def tweet_client
    @tweet_client ||= Newscloud::TweetList.new
  end

  def set_list_info
    list_info = tweet_list
    self.twitter_id_str = list_info["attrs"]["id_str"]
    self.description = list_info["attrs"]["description"]
  end

  def fetch_new_tweets since_tweet_id = nil
    last_tweet = since_tweet_id ? tweets.find_by_id(since_tweet_id) : latest_tweet

    tweet_client.fetch_raw_list list_username, list_name, last_tweet.try(:twitter_id_str)
  end

  def latest_tweet
    tweets.sorted_twitter_id.first
  end

  def fetch_new_tweets!
    fetch_new_tweets.map do |raw_tweet|
      tweet = add_tweet! raw_tweet
    end
  end

  def add_tweet! raw_tweet
    tweet = Tweet.build_from_raw_tweet raw_tweet, self
    #self.last_fetched_tweet = tweet
    #self.save
    self.touch(:last_fetched_at)
    tweet
  end

  def async_update_tweet_stream
    Resque.enqueue(TweetStreamsWorker, self.id)
  end

  def self.async_update_tweet_streams
    Resque.enqueue(TweetStreamsWorker)
  end

  def to_s
    [list_username, list_name].join '/'
  end

end
