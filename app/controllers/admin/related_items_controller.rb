class Admin::RelatedItemsController < AdminController

  def index
    meta_search = {:s => "created_at desc"}.merge(params[:q] || {})
    @search = RelatedItem.search(meta_search)
    @search.build_grouping unless @search.groupings.any?
    @items = @search.result.paginate(:page => params[:page], :per_page => 20)

    render 'shared/admin/index_page', :layout => 'new_admin', :locals => {
      :items => @items,
      :model => RelatedItem,
      :fields => [:title, :url, :is_blocked, :created_at],
      :associations => { :belongs_to => { :user => :user_id } },
      :paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @related_item = RelatedItem.find(params[:id])

    render_edit @related_item
  end

  def update
    @related_item = RelatedItem.find(params[:id])
    if @related_item.update_attributes(params[:related_item])
      @related_item.expire
      flash[:success] = "Successfully updated your RelatedItem."
      redirect_to [:admin, @related_item]
    else
      flash[:error] = "Could not update your RelatedItem as requested. Please try again."
      render_edit @related_item
    end
  end

  def show
    render 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => RelatedItem.find(params[:id]),
      :model => RelatedItem,
      :fields => [:title, :url, :notes, :is_blocked, :user_id,:relatable_id, :created_at],
      :associations => { :belongs_to => { :user => :user_id, :relatable => :relatable_id } }
    }
  end

  def create
    @related_item = RelatedItem.new(params[:related_item])
    if @related_item.save
      flash[:success] = "Successfully created your new RelatedItem!"
      redirect_to [:admin, @related_item]
    else
      flash[:error] = "Could not create your RelatedItem, please try again"
      render_new @related_item
    end
  end

  def destroy
    @related_item = RelatedItem.find(params[:id])
    @related_item.destroy

    redirect_to admin_related_items_path
  end

  private

  def render_new related_item = nil
    related_item ||= RelatedItem.new

    render 'shared/admin/new_page', :layout => 'new_admin', :locals => {
      :item => @related_item,
      :model => RelatedItem,
      :fields => [:title, :url, :notes, :user_id, :relatable_type, :relatable_id, :is_blocked],
      :associations => { :belongs_to => { :user => :user_id } },
    }
  end

  def render_edit related_item
    render 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
      :item => related_item,
      :model => RelatedItem,
      :fields => [:title, :url, :notes, :user_id, :is_blocked ],
      :associations => { :belongs_to => { :user => :user_id, :relatable => :relatable_id } }
    }
  end

  def set_current_tab
    @current_tab = 'related_items';
  end

end
