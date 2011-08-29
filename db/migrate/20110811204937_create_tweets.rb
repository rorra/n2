class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.string  :tweet_item_type
      t.integer :tweet_item_id
      t.integer :tweet_stream_id
      t.integer :tweet_account_id
      t.string  :twitter_id_str
      t.string  :text
      t.text    :raw_tweet

      # Default fields
      t.integer  :votes_tally,    :default => 0
      t.integer  :comments_count, :default => 0
      t.boolean  :is_featured,    :default => false
      t.datetime :featured_at,    :default => nil
      t.integer  :flags_count,    :default => 0
      t.boolean  :is_blocked,     :default => false

      t.timestamps
    end

    add_index :tweets, :tweet_stream_id
    add_index :tweets, :twitter_id_str, :unique => true
  end

  def self.down
    drop_table :tweets
  end
end
