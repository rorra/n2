class Admin::MenuItemsController < AdminController

  def index
  end

  def save
    params[:items].each do |position, item_vals|
      menu_item = MenuItem.find(item_vals["id"])
      enabled = item_vals["enabled"] == "1"
      menu_item.update_attributes(:position => position, :enabled => enabled, :parent_id => nil)

      if item_vals["children"].present?
        item_vals["children"].each do |child_position, child_vals|
          child_item = MenuItem.find(child_vals["id"])
          child_item.update_attributes(
                                       :position => child_position,
                                       :enabled => (enabled and child_vals["enabled"] == "1"),
                                       :parent_id => menu_item.id)
        end
      end
    end
    render :json => {:success => "Success!"}.to_json and return
  end

end
