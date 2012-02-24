module GalleriesHelper
  def gallery_item_path item
    "/galleries/show_item/#{item.gallery.id}/#{item.id}"
  end

  def gallery_item_url item, include_root
    gallery_item_path item
  end
end
