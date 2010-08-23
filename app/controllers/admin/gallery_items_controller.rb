class Admin::GalleryItemsController < AdminController

  def index
    render :partial => 'shared/admin/index_page', :layout => 'new_admin', :locals => {
    	:items => GalleryItem.paginate(:page => params[:page], :per_page => 20, :order => "created_at desc"),
    	:model => GalleryItem,
    	:fields => [:title, :comments_count, :created_at],
    	:paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @gallery_item = GalleryItem.find(params[:id])

    render_edit @gallery_item
  end

  def update
    @gallery_item = GalleryItem.find(params[:id])
    if @gallery_item.update_attributes(params[:gallery_item])
      flash[:success] = "Successfully updated your Gallery Item."
      redirect_to [:admin, @gallery_item]
    else
      flash[:error] = "Could not update your GalleryItem as requested. Please try again."
      render_edit @gallery_item
    end
  end

  def show
    render :partial => 'shared/admin/show_page', :layout => 'new_admin', :locals => {
    	:item => GalleryItem.find(params[:id]),
    	:model => GalleryItem,
    	:fields => [:title, :comments_count, :created_at],
    }
  end

  def create
    @gallery_item = GalleryItem.new(params[:gallery_item])
    if @gallery_item.save
      flash[:success] = "Successfully created your new GalleryItem!"
      redirect_to [:admin, @gallery_item]
    else
      flash[:error] = "Could not create your GalleryItem, please try again"
      render_new @gallery_item
    end
  end

  def destroy
    @gallery_item = GalleryItem.find(params[:id])
    @gallery_item.destroy

    redirect_to admin_gallery_items_path
  end

  private

  def render_new gallery_item = nil
    gallery_item ||= GalleryItem.new

    render :partial => 'shared/admin/new_page', :layout => 'new_admin', :locals => {
    	:item => @gallery_item,
    	:model => GalleryItem,
    	:fields => [:title, :gallery_id],
    	:associations => { :belongs_to => { :user => :user_id , :gallery => :gallery_id }  }
    }
  end

  def render_edit gallery_item
    render :partial => 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
    	:item => gallery_item,
    	:model => GalleryItem,
    	:fields => [:title],
    	:associations => { :belongs_to => { :user => :user_id , :gallery => :gallery_id }  }
    }
  end

  def set_current_tab
    @current_tab = 'gallery_items';
  end

end
