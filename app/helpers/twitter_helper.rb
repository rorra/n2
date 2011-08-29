module TwitterHelper

  def tweet_blurb item
    return item.item_description unless item.respond_to?(:twitter_item?) and item.twitter_item? and item.primary_tweet.present?
    [
      local_linked_profile_name(item.primary_tweet.user),
      "tweeted:",
      item.primary_tweet.text
    ].join(' ').html_safe
  end

end
