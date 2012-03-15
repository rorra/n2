class Admin::CommentsController < AdminController

  def index
    meta_search = {:s => "created_at desc"}.merge(params[:q] || {})
    @search = Comment.search(meta_search)
    @search.build_grouping unless @search.groupings.any?
    @items = @search.result.paginate(:page => params[:page], :per_page => 20)

    render 'shared/admin/index_page', :layout => 'new_admin', :locals => {
      :items => @items,
      :model => Comment,
      :fields => [:comments, :user_id, :created_at],
      :associations => { :belongs_to => { :user => :user_id } },
      :paginate => true
    }
  end

  def new
    render 'shared/admin/new_page', :layout => 'new_admin', :locals => {
      :model => Comment,
      :fields => [:comments, :created_at],
    }
  end

  def edit
    @comment = Comment.find(params[:id])
    render 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
      :item => @comment,
      :model => Comment,
      :fields => [:comments],
    }
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      @comment.expire
      flash[:success] = "Successfully updated your Comment."
      redirect_to [:admin, @comment]
    else
      flash[:error] = "Could not update your Comment as requested. Please try again."
      render :edit
    end
  end

  def show
    render 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => Comment.find(params[:id]),
      :model => Comment,
      :fields => [:comments, :postedByName, :created_at, :is_blocked],
    }
  end

  def create
    @comment = Comment.new(params[:comment])
    if @comment.save
      flash[:success] = "Successfully created your new Comment!"
      redirect_to [:admin, @comment]
    else
      flash[:error] = "Could not create your Comment, please try again"
      render :new
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    redirect_to admin_Comments_path
  end

  private

  def set_current_tab
    @current_tab = 'Comments';
  end

end
