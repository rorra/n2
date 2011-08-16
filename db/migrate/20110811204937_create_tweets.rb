class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.integer :tweet_stream_id
      t.string :twitter_id_str
      t.string :text
      t.text :raw_tweet

      t.timestamps
    end

    add_index :tweets, :tweet_stream_id
    add_index :tweets, :twitter_id_str, :unique => true
  end

  def self.down
    drop_table :tweets
  end
end
