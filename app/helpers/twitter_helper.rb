module TwitterHelper

  def tweet_blurb item
    return item.item_description unless item.respond_to?(:twitter_item?) and item.twitter_item? and item.primary_tweet.present?
    [
      #local_linked_profile_name(item.primary_tweet.user),
      #"tweeted:",
      item.primary_tweet.text.gsub(Newscloud::Util.url_regex,"").gsub(/\s{2,}/," ")
    ].join(' ').html_safe
  end

  def tweet_url item
    if item.is_a? Tweet
      tweet = item
    elsif item.respond_to?(:twitter_item?) and item.twitter_item? and item.primary_tweet.present?
      tweet = item.primary_tweet
    else
      tweet = nil
    end
    return nil unless tweet
    
    "http://twitter.com/#!#{tweet.tweet_account.screen_name}/status/#{tweet.twitter_id_str}"
  end

end
