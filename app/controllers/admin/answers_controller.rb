class Admin::AnswersController < AdminController
  skip_before_filter :admin_user_required

  def index
    meta_search = {:s => "created_at desc"}.merge(params[:q] || {})
    @search = Answer.search(meta_search)
    @search.build_grouping unless @search.groupings.any?
    @items = @search.result.paginate(:page => params[:page], :per_page => 20)
    render 'shared/admin/index_page', :layout => 'new_admin', :locals => {
      :items => @items,
      :model => Answer,
      :fields => [:answer, :user_id, :votes_tally, :comments_count, :created_at, :question_id],
      :associations => { :belongs_to => { :question => :question_id, :user => :user_id } },
      :paginate => true
    }
  end

  def new
    @item = Answer.new
    render 'shared/admin/new_page', :layout => 'new_admin', :locals => {
      :item => @item,
      :model => Answer,
      :fields => [:answer]
    }
  end

  def edit
    @item = Answer.find(params[:id])
    render 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
      :item => @item,
      :model => Answer,
      :fields => [:answer]
    }  end

  def update
    @item = Answer.find(params[:id])
    if @item.update_attributes(params[:answer])
      @item.expire
      flash[:success] = "Successfully updated your Answer"
      redirect_to [:admin, @item]
    else
      flash[:error] = "Please clear any errors and try again"
      render 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
        :item => @item,
        :model => Answer,
        :fields => [:answer]
      }
    end
  end

  def show
    render 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => Answer.find(params[:id]),
      :model => Answer,
      :fields => [:answer, :question_id, :user_id, :votes_tally, :comments_count, :created_at],
      :associations => { :belongs_to => {  :question => :question_id, :user => :user_id } }
    }
  end

  def create
    @item = Answer.new(params[:answer])
    if @item.save
      flash[:success] = "Successfully created your new Answer!"
      redirect_to [:admin, @item]
    else
      flash[:error] = "Please clear any errors and try again"
      render 'shared/admin/new_page', :layout => 'new_admin', :locals => {
        :item => @item,
        :model => Answer,
        :fields => [:answer]
      }
    end
  end

  private

  def set_current_tab
    @current_tab = 'answers';
  end

end
