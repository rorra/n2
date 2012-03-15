class Admin::ResourcesController < AdminController

  cache_sweeper :resource_sweeper, :only => [:create, :update, :destroy]

  def index
    meta_search = {:s => "created_at desc"}.merge(params[:q] || {})
    @search = Resource.search(meta_search)
    @search.build_grouping unless @search.groupings.any?
    @items = @search.result.paginate(:page => params[:page], :per_page => 20)
    render 'shared/admin/index_page', :layout => 'new_admin', :locals => {
      :items => @items,
      :model => Resource,
      :fields => [:title, :user_id, :votes_tally, :comments_count, :created_at, :resource_section_id],
      :associations => { :belongs_to => { :resource_section => :resource_section_id, :user => :user_id } },
      :paginate => true
    }
  end

  def new
    @resource = Resource.new
  end

  def edit
    @resource = Resource.find(params[:id])
  end

  def update
    @resource = Resource.find(params[:id])
    if @resource.update_attributes(params[:resource])
      @resource.expire
      flash[:success] = "Successfully updated your Resource ."
      redirect_to [:admin, @resource]
    else
      flash[:error] = "Could not update your Resource  as requested. Please try again."
      render :edit
    end
  end

  def show
    render 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => Resource.find(params[:id]),
      :model => Resource,
      :fields => [:title, :user_id, :details, :votes_tally, :comments_count, :created_at, :resource_section_id],
      :associations => { :belongs_to => { :resource_section => :resource_section_id, :user => :user_id } },
    }
  end

  def create
    @resource = Resource.new(params[:resource])
    @resource.user = current_user
    if @resource.save
      flash[:success] = "Successfully created your new Resource !"
      redirect_to [:admin, @resource]
    else
      flash[:error] = "Could not create your Resource , please try again"
      render :new
    end
  end

  private

  def set_current_tab
    @current_tab = 'resources';
  end

end
