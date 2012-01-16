class CreateItemScores < ActiveRecord::Migration
  def self.up
    create_table :item_scores do |t|
      t.string  :scorable_type
      t.integer :scorable_id
      t.float   :score, :default => 0.0
      t.integer :positive_actions_count, :default => 0
      t.integer :negative_actions_count, :default => 0
      t.boolean :is_blocked, :default => false

      t.timestamps
    end

    add_index :item_scores, [:scorable_type, :scorable_id]
    add_index :item_scores, :scorable_type
    add_index :item_scores, :score
    add_index :item_scores, :positive_actions_count
    add_index :item_scores, :negative_actions_count
    add_index :item_scores, :is_blocked
  end

  def self.down
    drop_table :item_scores
  end
end
