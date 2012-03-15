class Admin::AnswersController < AdminController
  skip_before_filter :admin_user_required

  admin_scaffold :answers do |config|
    config.index_fields = [:answer, :user_id, :votes_tally, :comments_count, :created_at, :question_id]
    config.show_fields = [:answer, :question_id, :user_id, :votes_tally, :comments_count, :created_at]
    config.new_fields   = [:question_id, :answer]
    config.edit_fields  = [:answer]
    config.actions = [:index, :show, :new, :create, :edit, :update]
    config.associations = { :belongs_to => { :question => :question_id, :user => :user_id } }
  end

  private

  def set_current_tab
    @current_tab = 'answers';
  end

end
