class Admin::GalleryItemsController < AdminController

  admin_scaffold :gallery_item do |config|
    config.index_fields = [:title, :description, :user_id]
    config.actions = [:show, :edit]
    config.associations = { :belongs_to => { :gallery => :gallery_id } }
  end

end
