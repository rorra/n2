class Admin::CommentsController < AdminController

  admin_scaffold :comments do |config|
    config.index_fields = [:comments, :user_id, :created_at]
    config.show_fields = [:answer, :question_id, :user_id, :votes_tally, :comments_count, :created_at]
    config.new_fields   = [:user_id, :comments]
    config.edit_fields  = [:comments]
    config.actions = [:index, :show, :new, :create, :edit, :update]
    config.associations = { :belongs_to => { :user => :user_id } }
  end

  private

  def set_current_tab
    @current_tab = 'Comments';
  end

end
