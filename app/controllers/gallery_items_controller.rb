class GalleryItemsController < ApplicationController
  access_control do
    allow all, :to => [:show]
  end

  def show
    @item = GalleryItem.find params[:id]
    @gallery = @item.gallery
  end

end
