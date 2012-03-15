class Admin::AnnouncementsController < AdminController
  cache_sweeper :announcement_sweeper, :only => [:create, :update, :destroy]

  admin_scaffold :announcements do |config|
    config.index_fields = [:prefix, :title, :url, :created_at]
    config.show_fields = [:prefix, :title, :details, :url, :created_at]
    config.new_fields   = [:prefix, :title, :details, :url]
    config.edit_fields  = [:prefix, :title, :details, :url]
    config.actions = [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  private

  def set_current_tab
    @current_tab = 'announcements';
  end

end
