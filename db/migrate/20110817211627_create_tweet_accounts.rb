class CreateTweetAccounts < ActiveRecord::Migration
  def self.up
    create_table :tweet_accounts do |t|
      t.integer :user_id, :default => nil
      t.string  :twitter_id_str
      t.string  :name
      t.string  :screen_name
      t.string  :profile_image_url
      t.text    :description

      t.timestamps
    end

    add_index :tweet_accounts, :twitter_id_str
    add_index :tweet_accounts, :user_id
    add_index :tweet_accounts, :screen_name
  end

  def self.down
    drop_table :tweet_accounts
  end
end
