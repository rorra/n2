class ItemTweet < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
  belongs_to :tweet

  named_scope :primary_items, :conditions => { :primary_item => true }

  after_save :expire

  def self.create_from_item_and_tweet! item, tweet, primary_item = false
    ItemTweet.create!({
      :item         => item,
      :tweet        => tweet,
      :primary_item => primary_item
    })
  end

  def expire
    tweet.expire
    item.expire
  end

end
