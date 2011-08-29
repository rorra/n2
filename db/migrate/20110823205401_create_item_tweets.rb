class CreateItemTweets < ActiveRecord::Migration
  def self.up
    create_table :item_tweets do |t|
      t.string :item_type
      t.integer :item_id
      t.integer :tweet_id
      t.boolean :primary_item, :default => false

      t.timestamps
    end

    add_index :item_tweets, [:item_type, :item_id]
    add_index :item_tweets, :tweet_id
  end

  def self.down
    drop_table :item_tweets
  end
end
