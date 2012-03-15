class Admin::IdeasController < AdminController

  def index
    meta_search = {:s => "created_at desc"}.merge(params[:q] || {})
    @search = Idea.search(meta_search)
    @search.build_grouping unless @search.groupings.any?
    @items = @search.result.paginate(:page => params[:page], :per_page => 20)

    render 'shared/admin/index_page', :layout => 'new_admin', :locals => {
      :items => @items,
      :model => Idea,
      :fields => [:title, :user_id, :votes_tally, :comments_count, :created_at, :idea_board_id],
      :associations => { :belongs_to => { :idea_board => :idea_board_id, :user => :user_id } },
      :paginate => true
    }
  end

  def new
    @idea = Idea.new
  end

  def edit
    @idea = Idea.find(params[:id])
  end

  def update
    @idea = Idea.find(params[:id])
    if @idea.update_attributes(params[:idea])
      @idea.expire
      flash[:success] = "Successfully updated your Idea ."
      redirect_to [:admin, @idea]
    else
      flash[:error] = "Could not update your Idea  as requested. Please try again."
      render :edit
    end
  end

  def show
    render 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => Idea.find(params[:id]),
      :model => Idea,
      :fields => [:title, :user_id, :details, :votes_tally, :comments_count, :created_at, :idea_board_id],
      :associations => { :belongs_to => { :idea_board => :idea_board_id, :user => :user_id } }
    }  end

  def create
    @idea = Idea.new(params[:idea])
    @idea.user = current_user
    if @idea.save
      flash[:success] = "Successfully created your new Idea !"
      redirect_to [:admin, @idea]
    else
      flash[:error] = "Could not create your Idea , please try again"
      render :new
    end
  end

  private

  def set_current_tab
    @current_tab = 'ideas';
  end

end
