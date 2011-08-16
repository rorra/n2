class CreateTweetStreams < ActiveRecord::Migration
  def self.up
    create_table :tweet_streams do |t|
      t.string   :list_name
      t.string   :list_username
      t.string   :twitter_id_str
      t.text     :description
      t.datetime :last_fetched_at,       :default => nil
      t.integer  :last_fetched_tweet_id, :default => nil
      t.integer  :tweets_count,          :default => 0

      # Default fields
      t.integer  :votes_tally,    :default => 0
      t.integer  :comments_count, :default => 0
      t.boolean  :is_featured,    :default => false
      t.datetime :featured_at,    :default => nil
      t.integer  :flags_count,    :default => 0
      t.boolean  :is_blocked,     :default => false

      t.timestamps
    end

    add_index :tweet_streams, :twitter_id_str
    add_index :tweet_streams, [:list_username, :list_name]
    add_index :tweet_streams, :is_blocked
  end

  def self.down
    drop_table :tweet_streams
  end
end
