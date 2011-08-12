class CreateUrls < ActiveRecord::Migration
  def self.up
    create_table :urls do |t|
      t.integer :source_id
      t.string :url

      t.timestamps
    end

    add_index :urls, :source_id
    add_index :urls, :url
  end

  def self.down
    drop_table :urls
  end
end
