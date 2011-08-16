class Tweet < ActiveRecord::Base

  has_many :tweet_urls
  has_many :urls, :through => :tweet_urls
  belongs_to :tweet_stream, :counter_cache => true, :touch => true
  named_scope :sorted_twitter_id, :order => "twitter_id_str desc"

  def raw_urls
    #@raw_urls ||= text.scan(%r{http://[^\s]+})
    raw_json["entities"]["urls"].map {|u| u["url"] }.flatten
  end

  def raw_json
    @raw_json ||= JSON.parse(raw_tweet)
  end

  def self.build_from_raw_tweet raw_tweet, stream
    tweet = Tweet.create!({
      :twitter_id_str => raw_tweet["id_str"],
      :text           => raw_tweet["text"],
      :raw_tweet      => raw_tweet.to_json,
      :tweet_stream   => stream
    })
    raw_urls = Newscloud::TweetList.extract_raw_urls raw_tweet
    Newscloud::TweetList.fetch_real_urls(raw_urls).each do |url_str|
      url = Url.find_or_create_by_url(url_str)
      TweetUrl.create!({
        :tweet => tweet,
        :url   => url
      })
    end
    tweet
  end

end
