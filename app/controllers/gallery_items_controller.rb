class GalleryItemsController < ApplicationController
  before_filter :logged_in_to_facebook_and_app_authorized, :only => [:new, :create, :update, :my_gallery_items], :if => :request_comes_from_facebook?

#  cache_sweeper :gallery_item_sweeper, :only => [:create, :update, :destroy]

  before_filter :set_current_tab
  before_filter :login_required, :only => [:new, :create, :update, :my_gallery_items]
  before_filter :set_gallery
#  before_filter :load_top_gallery_items
#  before_filter :load_newest_gallery_items
#  before_filter :load_featured_gallery_items, :only => [:index]
#  before_filter :load_newest_gallerys

  def index
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @current_sub_tab = 'Browse GalleryItems'
    @gallery_items = GalleryItem.active.paginate :page => params[:page], :per_page => GalleryItem.per_page, :order => "created_at desc"
    respond_to do |format|
      format.html { @paginate = true }
      format.json { @gallery_items = GalleryItem.refine(params) }
    end
  end

  def new
    @current_sub_tab = t('gallery.add')
    @gallery_item = GalleryItem.new
    @gallery_item.gallery = @gallery if @gallery.present?
    @gallery_items = GalleryItem.active.newest
  end

  def create
    @gallery_item = GalleryItem.new(params[:gallery_item])
    @gallery_item.tag_list = params[:gallery_item][:tags_string]
    @gallery_item.user = current_user
    if params[:gallery_item][:gallery_id].present?
    	@gallery = Gallery.find_by_id(params[:gallery_item][:gallery_id])
    	@gallery_item.section_list = @gallery.section unless @gallery.nil?
    end
    if @gallery_item.valid? and current_user.gallery_items.push @gallery_item
      if @gallery_item.post_wall?
        session[:post_wall] = @gallery_item
      end      
    	flash[:success] = "Thank you for your gallery_item!"
    	redirect_to @gallery.present? ? [@gallery, @gallery_item] : @gallery_item
    else
      @gallery_items = GalleryItem.active.newest
    	render :new
    end
  end

  def show
    @gallery_item = GalleryItem.find(params[:id])
    tag_cloud @gallery_item
  end

  def my_gallery_items
    @paginate = true
    @current_sub_tab = 'My Gallery Items'
    @user = User.find(params[:id])
    @gallery_items = @user.gallery_items.active.paginate :page => params[:page], :per_page => GalleryItem.per_page, :order => "created_at desc"
  end

  def set_slot_data
    @ad_banner = Metadata.get_ad_slot('banner', 'gallery_items')
    @ad_leaderboard = Metadata.get_ad_slot('leaderboard', 'gallery_items')
    @ad_skyscraper = Metadata.get_ad_slot('skyscraper', 'gallery_items')
  end

  private

  def set_gallery
    @gallery = params[:gallery_id].present? ? Gallery.find(params[:gallery_id]) : nil
  end

  def set_current_tab
    @current_tab = 'gallery'
  end

end
