class Admin::ResourceSectionsController < AdminController

  cache_sweeper :resource_sweeper, :only => [:create, :update, :destroy]

  def index
    meta_search = {:s => "created_at desc"}.merge(params[:q] || {})
    @search = ResourceSection.search(meta_search)
    @search.build_grouping unless @search.groupings.any?
    @items = @search.result.paginate(:page => params[:page], :per_page => 20)
    render 'shared/admin/index_page', :layout => 'new_admin', :locals => {
      :items => @items,
      :model => ResourceSection,
      :fields => [:name, :description, :section],
      :associations => { :belongs_to => {:user => :user_id, :resource_section => :resource_section_id} },
      :paginate => true
    }
  end

  def new
    @item = ResourceSection.new
    render 'shared/admin/new_page', :layout => 'new_admin', :locals => {
      :item => @item,
      :model => ResourceSection,
      :fields => [:name, :section, :description]
    }
  end

  def edit
    @item = ResourceSection.find(params[:id])
    render 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
      :item => @item,
      :model => ResourceSection,
      :fields => [:name, :section, :description]
    }
  end

  def update
    @item = ResrouceSection.find(params[:id])
    if @resource_section.update_attributes(params[:resource_section])
      flash[:success] = "Successfully updated your Resource Section"
      redirect_to [:admin, @item]
    else
      flash[:error] = "Please clear any errors and try again"
      render 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
        :item => @item,
        :model => ResourceSection,
        :fields => [:name, :section, :description]
      }
    end
  end

  def show
    @resource_section = ResourceSection.find(params[:id])
  end

  def create
    @item = ResourceSection.new(params[:resource_section])
    if @item.save
      flash[:success] = "Successfully created your new Resource Section!"
      redirect_to [:admin, @item]
    else
      flash[:error] = "Please clear any errors and try again"
      render 'shared/admin/new_page', :layout => 'new_admin', :locals => {
        :item => @item,
        :model => ResourceSection,
        :fields => [:name, :section, :description]
      }
    end
  end

  def destroy
    @resource_section = ResourceSection.find(params[:id])
    @resource_section.destroy
    redirect_to admin_resource_sections_path
  end

  private

  def set_current_tab
    @current_tab = 'resource-sections';
  end

end
