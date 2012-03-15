class Admin::ForumsController < AdminController

  def index
    meta_search = {:s => "created_at desc"}.merge(params[:q] || {})
    @search = Forum.search(meta_search)
    @search.build_grouping unless @search.groupings.any?
    @items = @search.result.paginate(:page => params[:page], :per_page => 20)

    render 'shared/admin/index_page', :layout => 'new_admin', :locals => {
      :items => @items,
      :model => Forum,
      :fields => [:name, :description, :topics_count, :comments_count, :created_at],
      :paginate => true
    }
  end

  def reorder
    if request.post?
      begin
        params[:forums].map {|f| f.sub(/^forum-([0-9]+)$/, '\1') }.reverse.each_with_index do |forum_id, position|
          Forum.find_by_id(forum_id).update_attribute(:position, position + 1)
        end
        Forum.expire_all
        render :json => {:success => "Success!"}.to_json and return
      rescue
        render :json => {:success => "Could not save your new order!"}.to_json and return
      end
    end
  end

  def new
    render_new
  end

  def edit
    @forum = Forum.find(params[:id])

    render_edit @forum
  end

  def update
    @forum = Forum.find(params[:id])
    if @forum.update_attributes(params[:forum])
      @forum.expire
      flash[:success] = "Successfully updated your Forum."
      redirect_to [:admin, @forum]
    else
      flash[:error] = "Could not update your Forum as requested. Please try again."
      render_edit @forum
    end
  end

  def show
    render 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => Forum.find(params[:id]),
      :model => Forum,
      :fields => [:name, :description, :topics_count, :comments_count, :created_at],
    }
  end

  def create
    @forum = Forum.new(params[:forum])
    if @forum.save
      ForumSweeper.expire_forum_all @forum
      flash[:success] = "Successfully created your new Forum!"
      redirect_to [:admin, @forum]
    else
      flash[:error] = "Could not create your Forum, please try again"
      render_new @forum
    end
  end

  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy

    redirect_to admin_forums_path
  end

  private

  def render_new forum = nil
    forum ||= Forum.new

    render 'shared/admin/new_page', :layout => 'new_admin', :locals => {
      :item => forum,
      :model => Forum,
      :fields => [:name, :description],
      :include_media_form => true
    }
  end

  def render_edit forum
    render 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
      :item => forum,
      :model => Forum,
      :fields => [:name, :description],
      :include_media_form => true,
      :associations => { :belongs_to => { :user => :user_id } }
    }
  end

  def set_current_tab
    @current_tab = 'forums';
  end

end
