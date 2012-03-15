class Admin::FlagsController < AdminController
  admin_scaffold :flag do |config|
    config.index_fields = [:item_title, :item_description, :flag_type, :user_id, :flaggable_id, :flags_count, :is_blocked]
    config.show_fields = [:item_title, :item_description, :flag_type, :user_id, :flaggable_id, :flags_count, :is_blocked]
    config.actions = [:index, :show]
    config.associations = {:belongs_to => {:user => :user_id, :flaggable => :flaggable_id}}
  end

  private

  def set_current_tab
    @current_tab = 'contents'
  end

end
