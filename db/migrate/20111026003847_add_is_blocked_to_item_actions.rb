class AddIsBlockedToItemActions < ActiveRecord::Migration
  def self.up
    add_column :item_actions, :is_blocked, :boolean, :default => false
    add_index :item_actions, :is_blocked
  end

  def self.down
    remove_index :item_actions, :is_blocked
    remove_column :item_actions, :is_blocked
  end
end
