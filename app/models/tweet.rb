class Tweet < ActiveRecord::Base
  acts_as_moderatable
  acts_as_taggable_on :tags, :topics

  has_many :tweet_urls
  has_many :urls, :through => :tweet_urls
  belongs_to :tweet_stream, :counter_cache => true, :touch => true
  belongs_to :tweet_account
  has_many :item_tweets
  has_many :items, :through => :item_tweets

  named_scope :sorted_twitter_id, :order => "twitter_id_str desc"

  def user
    tweet_account.user
  end

  def raw_urls
    #@raw_urls ||= text.scan(%r{http://[^\s]+})
    raw_json["entities"]["urls"].map {|u| u["url"] }.flatten
  end

  def raw_json
    @raw_json ||= JSON.parse(raw_tweet)
  end

  def build_related
    urls.each do |tweet_url|
      next unless tweet_url.allowed_source?

      url = tweet_url.url
      begin
        page = Parse::Page.parse_page(url)
      rescue Exception
        return false
      end
      title = page[:title].present? ? page[:title] : url
      description = page[:description] ? page[:description] : "@#{tweet_account.screen_name} tweeted: #{text}"
      content = Content.find_by_url(url)
      unless content
        content = Content.new({
          :title   => title,
          :caption => description,
          :user    => user,
          :url     => url
        })
        if page[:images_sized].any? and Image.image_url?(page[:images_sized].first[:url])
          content.images.push Image.new(:remote_image_url => page[:images_sized].first[:url])
        end
      end
      begin
        user.contents.push content
        content.expire
      rescue Exception
        next
      end
      ItemTweet.create_from_item_and_tweet! content, self, true
    end
  end

  def self.build_from_raw_tweet raw_tweet, stream
    tweet = Tweet.find_by_twitter_id_str(raw_tweet["id_str"])
    return tweet if tweet

    tweet_account = TweetAccount.get_user_from_json(raw_tweet["user"])
    tweet = Tweet.create!({
      :twitter_id_str => raw_tweet["id_str"],
      :text           => raw_tweet["text"],
      :raw_tweet      => raw_tweet.to_json,
      :tweet_stream   => stream,
      :tweet_account  => tweet_account
    })
    raw_urls = Newscloud::TweetList.extract_raw_urls raw_tweet
    Newscloud::TweetList.fetch_real_urls(raw_urls).each do |url_str|
      begin
        url = Url.find_or_create_by_url(url_str)
      rescue Exception
        next
      end
      TweetUrl.create!({
        :tweet => tweet,
        :url   => url
      })
    end
    tweet
  end

end
