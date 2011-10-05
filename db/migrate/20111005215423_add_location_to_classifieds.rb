class AddLocationToClassifieds < ActiveRecord::Migration
  def self.up
    add_column :classifieds, :location_text, :string
  end

  def self.down
    remove_column :classifieds, :location_text
  end
end
