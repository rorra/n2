class Admin::QuestionsController < AdminController
  skip_before_filter :admin_user_required

  def index
    meta_search = {:s => "created_at desc"}.merge(params[:q] || {})
    @search = Question.search(meta_search)
    @search.build_grouping unless @search.groupings.any?
    @items = @search.result.paginate(:page => params[:page], :per_page => 20)
    render 'shared/admin/index_page', :layout => 'new_admin', :locals => {
      :items => @items,
      :model => Question,
      :fields => [:question, :details, :user_id, :votes_tally, :comments_count, :created_at],
      :associations => { :belongs_to => { :user => :user_id } },
      :paginate => true
    }
  end

  def new
    @question = Question.new
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(params[:question])
      @question.expire
      flash[:success] = "Successfully updated your Question ."
      redirect_to [:admin, @question]
    else
      flash[:error] = "Could not update your Question  as requested. Please try again."
      render :edit
    end
  end

  def show
    render 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => Question.find(params[:id]),
      :model => Question,
      :fields => [:question, :user_id, :details, :votes_tally, :comments_count, :created_at],
      :associations => { :belongs_to => {  :user => :user_id } }
    }
  end

  def create
    @question = Question.new(params[:question])
    @question.user = current_user
    if @question.save
      flash[:success] = "Successfully created your new Question !"
      redirect_to [:admin, @question]
    else
      flash[:error] = "Could not create your Question , please try again"
      render :new
    end
  end

  private

  def set_current_tab
    @current_tab = 'questions';
  end

end
