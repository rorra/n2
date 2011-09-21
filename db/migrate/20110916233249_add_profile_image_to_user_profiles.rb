class AddProfileImageToUserProfiles < ActiveRecord::Migration
  def self.up
    add_column :user_profiles, :profile_image, :string
  end

  def self.down
    remove_column :user_profiles, :profile_image
  end
end
