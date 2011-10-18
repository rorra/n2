class AddMoreMetadataToAuthentications < ActiveRecord::Migration
  def self.up
    add_column :authentications, :nickname, :string
    add_column :authentications, :description, :string
    add_column :authentications, :raw_output, :text
  end

  def self.down
    remove_column :authentications, :nickname, :string
    remove_column :authentications, :description, :string
    remove_column :authentications, :raw_output, :text
  end
end
