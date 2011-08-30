class CreateTweetUrls < ActiveRecord::Migration
  def self.up
    create_table :tweet_urls do |t|
      t.integer :tweet_id
      t.integer :url_id
      t.timestamps
    end

    add_index :tweet_urls, :tweet_id
    add_index :tweet_urls, :url_id
    add_index :tweet_urls, [:tweet_id, :url_id]
  end

  def self.down
    drop_table :tweet_urls
  end
end
