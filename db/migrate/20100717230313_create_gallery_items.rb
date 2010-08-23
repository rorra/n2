class CreateGalleryItems < ActiveRecord::Migration
  def self.up
    create_table :gallery_items do |t|
      t.integer :user_id
      t.string :title
      t.text :caption, :limit => 1000
      t.integer  :votes_tally,                 :default => 0
      t.integer  :comments_count,              :default => 0
      t.boolean  :is_featured,                 :default => false
      t.datetime :featured_at
      t.integer  :flags_count,                 :default => 0
      t.boolean  :is_blocked,                  :default => false
      t.integer  :gallery_id
      t.timestamps
    end

  end

  def self.down
    drop_table :gallery_items
  end
end
