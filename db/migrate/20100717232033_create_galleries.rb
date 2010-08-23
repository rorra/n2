class CreateGalleries < ActiveRecord::Migration
   def self.up
    create_table :galleries do |t|
      t.string :name
      t.string :section
      t.text :description, :limit => 1000
      t.timestamps
    end
  end

  def self.down
    drop_table :galleries
  endend
