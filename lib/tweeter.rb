require 'action_controller'
require 'net/http'

include ActionController::UrlWriter

module Newscloud

  class TweeterDisabled < Exception
  end

  class TweeterNotConfigured < Exception
  end

  class TweetList

    def initialize
      @oauth_key = Metadata::Setting.find_setting('oauth_key').try(:value)
      @oauth_secret = Metadata::Setting.find_setting('oauth_secret').try(:value)
      @oauth_consumer_key = Metadata::Setting.find_setting('oauth_consumer_key').try(:value)
      @oauth_consumer_secret =  Metadata::Setting.find_setting('oauth_consumer_secret').try(:value)
      Twitter.configure do |config|
        config.consumer_key = @oauth_key
        config.consumer_secret = @oauth_secret
        config.oauth_token = @oauth_consumer_key
        config.oauth_token_secret = @oauth_consumer_secret
      end
    end

    def client
      @client ||= Twitter::Client.new(:oauth_token => @oauth_consumer_key, :oauth_token_secret => @oauth_consumer_secret)
    end

    def consumer
      @consumer ||= OAuth::Consumer.new(@oauth_key, @oauth_secret)
    end

    def fetch_list user, name
      tweets = fetch_raw_list user, name
      urls = tweets.map {|t| t["text"].scan(%r{http://[^\s]+}) }.flatten
      self.class.fetch_real_urls urls
    end

    def save_list user, name
      tweets = fetch_raw_list user, name
      urls = tweets.map {|t| t["text"].scan(%r{http://[^\s]+}) }.flatten
      self.class.fetch_real_urls urls
      tweets.each do |raw_tweet|
        tweet = Tweet.create!({
          :twitter_id_str => raw_tweet["id_str"],
          :text           => raw_tweet["text"],
          :raw_tweet      => raw_tweet.to_json
        })
        self.class.fetch_real_urls(tweet.raw_urls).each do |url_str|
          url = Url.find_or_create_by_url(url_str)
          TweetUrl.create!({
            :tweet => tweet,
            :url   => url
          })
        end
      end
    end

    def fetch_raw_list user, name
      client.list_timeline(user,name)
    end

    def self.fetch_real_url url_str
      location = nil
      loc = url_str
      while loc = self.fetch_url_location(loc)
        location = loc
      end
      location || url_str
    end

    def self.fetch_url_location url_str
      url = URI.parse(url_str.strip)
      req = Net::HTTP.new(url.host, url.port)
      path = url.path.present? ? url.path : '/'
      resp, data = req.get(path, nil)
      resp.header['location']
    end

    def self.fetch_real_urls urls
      urls.map {|url| self.fetch_real_url url }
    end
  end

  class Tweeter

    def initialize
      default_url_options[:host] = APP_CONFIG['base_site_url'].sub(%r{^https?://}, '')
      @base_oauth_key = "U6qjcn193333331AuA"
      @base_oauth_secret= "Heu0GGaRuzn762323gg0qFGWCp923viG8Haw"

      @enabled = Metadata::Setting.find_setting('tweet_popular_items').try(:value)
      raise Newscloud::TweeterDisabled.new("You must enable the setting 'tweet_popular_items' to use Tweeter.") unless @enabled

      @oauth_key = Metadata::Setting.find_setting('oauth_key').try(:value)
      @oauth_secret = Metadata::Setting.find_setting('oauth_secret').try(:value)
      @oauth_consumer_key = Metadata::Setting.find_setting('oauth_consumer_key').try(:value)
      @oauth_consumer_secret =  Metadata::Setting.find_setting('oauth_consumer_secret').try(:value)

      unless @oauth_key and @oauth_consumer_key and @oauth_secret and @oauth_consumer_secret
        raise Newscloud::TweeterNotConfigured.new("You must configure your oauth settings and run the rake twitter connect task.")
      end

      if @oauth_key == @base_oauth_key or @oauth_consumer_key == @base_oauth_key or
      	 @oauth_secret == @base_oauth_secret or @oauth_consumer_secret == @base_oauth_secret
      	  raise Newscloud::TweeterNotConfigured.new("You must configure your oauth settings and run the rake twitter connect task.")
      end

      Twitter.configure do |config|
        config.consumer_key = @oauth_key
        config.consumer_secret = @oauth_secret
        config.oauth_token = @oauth_consumer_key
        config.oauth_token_secret = @oauth_consumer_secret
      end
      @twitter = Twitter::Client.new
    end

    def tweet_items items
      items.each {|item| tweet_item(item) }
    end

    def tweet_item item
      # TODO:: setup facebook canvas url option
      status = tweet "#{item.item_title} #{self.class.shorten_url(polymorphic_path(item, :only_path => false))}"
      item.create_tweeted_item if status
    end

    def tweet msg
      begin
        @twitter.update(msg)
      rescue Exception => e
        Rails.logger.error("ERROR TWEETING: (#{msg}) -- #{e}")
        return false
      end
    end

    def tweet_hot_items
      klasses = Dir.glob("#{RAILS_ROOT}/app/models/*.rb").map {|f| f.sub(%r{^.*/(.*?).rb$}, '\1').pluralize.classify }.map(&:constantize).select {|m| m.respond_to?(:tweetable?) and m.tweetable? }
      klasses.each do |klass|
        hot_items = klass.hot_items
        next unless hot_items
        puts "Hot items for #{klass.name.titleize}"
        puts hot_items.inspect
        tweet_items hot_items
      end
    end

    def self.shorten_url(url)
      @bitly_username = Metadata::Setting.find_setting('bitly_username').try(:value)
      @bitly_api_key = Metadata::Setting.find_setting('bitly_api_key').try(:value)

      if @bitly_username and @bitly_api_key
      	bitly = Bitly.new(@bitly_username, @bitly_api_key)
      	bitly.shorten(url).short_url
      else
      	url
      end
    end

  end

end
