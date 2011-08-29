class CreateUrls < ActiveRecord::Migration
  def self.up
    create_table :urls do |t|
      t.integer :source_id
      t.string :url

      # Default fields
      t.integer  :votes_tally,    :default => 0
      t.integer  :comments_count, :default => 0
      t.boolean  :is_featured,    :default => false
      t.datetime :featured_at,    :default => nil
      t.integer  :flags_count,    :default => 0
      t.boolean  :is_blocked,     :default => false

      t.timestamps
    end

    add_index :urls, :source_id
    add_index :urls, :url
  end

  def self.down
    drop_table :urls
  end
end
