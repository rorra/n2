class UpdateSourceModelForTweetStreams < ActiveRecord::Migration
  def self.up
    add_column :sources, :white_list, :boolean, :default => false
    add_column :sources, :black_list, :boolean, :default => false

    add_index :sources, :white_list
    add_index :sources, :black_list

    add_index :sources, :url
  end

  def self.down
    remove_index :sources, :url

    remove_index :sources, :white_list
    remove_index :sources, :black_list

    remove_column :sources, :white_list
    remove_column :sources, :black_list
  end
end
