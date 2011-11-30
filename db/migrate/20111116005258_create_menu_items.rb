class CreateMenuItems < ActiveRecord::Migration
  def self.up
    create_table :menu_items do |t|
      t.string :menuitemable_type
      t.integer :menuitemable_id
      t.integer :parent_id, :default => nil
      t.boolean :enabled, :default => true
      t.integer :position, :default => 0
      t.string :resource_path, :default => nil
      t.string :url, :default => nil
      t.string :name
      t.string :name_slug
      t.string :locale_string

      t.timestamps
    end

    add_index :menu_items, :parent_id
    add_index :menu_items, :enabled
    add_index :menu_items, :name_slug
    add_index :menu_items, [:menuitemable_type, :menuitemable_id]
  end

  def self.down
    drop_table :menu_items
  end
end
