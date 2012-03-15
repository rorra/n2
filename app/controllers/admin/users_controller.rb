class Admin::UsersController < AdminController
  admin_scaffold :user do |config|
    config.index_fields = [:name, :fb_user_id, :email, :is_admin, :is_blocked, :cached_slug, :karma_score]
    config.new_fields   = [:name, :email, :is_admin, :is_editor, :is_moderator, :is_host, :is_blocked, :cached_slug, :karma_score ]
    config.edit_fields  = [:name, :email, :is_admin, :is_editor, :is_moderator, :is_host, :is_blocked, :cached_slug, :karma_score ]
    config.actions      = [:index, :show, :edit, :new, :create, :update]
  end

  private

  def set_current_tab
    @current_tab = 'users';
  end

end
