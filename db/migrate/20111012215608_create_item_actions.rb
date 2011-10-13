class CreateItemActions < ActiveRecord::Migration
  def self.up
    create_table :item_actions do |t|
      t.string  :actionable_type
      t.integer :actionable_id
      t.integer :user_id
      t.string :action_type
      t.string :url

      t.timestamps
    end

    add_index :item_actions, :user_id
    add_index :item_actions, :action_type
    add_index :item_actions, [:actionable_type, :actionable_id]
  end

  def self.down
    remove_index :item_actions, :user_id
    remove_index :item_actions, :action_type
    remove_index :item_actions, [:actionable_type, :actionable_id]
    drop_table :item_actions
  end
end
