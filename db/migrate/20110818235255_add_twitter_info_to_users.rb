class AddTwitterInfoToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter_user, :boolean, :default => false
    add_column :users, :system_user, :boolean, :default => false
    
    add_index :users, :twitter_user
    add_index :users, :system_user
  end

  def self.down
    remove_index :users, :twitter_user
    remove_index :users, :system_user

    remove_column :users, :twitter_user
    remove_column :users, :system_user
  end
end
