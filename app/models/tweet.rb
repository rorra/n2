class Tweet < ActiveRecord::Base

  has_many :tweet_urls
  has_many :urls, :through => :tweet_urls

  def raw_urls
    @raw_urls ||= text.scan(%r{http://[^\s]+})
  end

  def raw_json
    @raw_json ||= JSON.parse(raw_tweet)
  end

end
