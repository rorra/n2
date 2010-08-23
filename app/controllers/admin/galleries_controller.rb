class Admin::GalleriesController < AdminController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => Gallery.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => Gallery,
    	:fields => [:name, :section, :created_at],
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @gallery = Gallery.find(params[:id])

    render_edit @gallery
  end

  def update
    @gallery = Gallery.find(params[:id])
    if @gallery.update_attributes(params[:gallery])
      flash[:success] = "Successfully updated your Gallery."
      redirect_to [:admin, @gallery]
    else
      flash[:error] = "Could not update your Gallery as requested. Please try again."
      render_edit @gallery
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => Gallery.find(params[:id]),
    	:model => Gallery,
    	:fields => [:name, :url, :all_subdomains_valid, :created_at],
    }
  end

  def create
    @gallery = Gallery.new(params[:gallery])
    @gallery.url = params[:gallery][:url].sub(/^\/+/,'').sub(/^http:\/\/(www.)*/,'').strip.sub(/\/+$/,'')
    if @gallery.save
      flash[:success] = "Successfully created your new Gallery!"
      redirect_to [:admin, @gallery]
    else
      flash[:error] = "Could not create your Gallery, please try again"
      render_new @gallery
    end
  end

  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy

    redirect_to admin_galleries_path
  end

  private

  def render_new gallery = nil
    gallery ||= Gallery.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => @gallery,
    	:model => Gallery,
    	:fields => [:name, :section, :created_at],
    }
  end

  def render_edit gallery
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => gallery,
    	:model => Gallery,
    	:fields => [:name, :section, :created_at],
    }
  end

  def set_current_tab
    @current_tab = 'galleries';
  end

end
