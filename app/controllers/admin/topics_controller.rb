class Admin::TopicsController < AdminController

  def index
    meta_search = {:s => "created_at desc"}.merge(params[:q] || {})
    @search = Topic.search(meta_search)
    @search.build_grouping unless @search.groupings.any?
    @items = @search.result.paginate(:page => params[:page], :per_page => 20)

    @config = OpenStruct.new
    @config.actions = [:index, :show, :new, :create, :edit, :update, :destroy]

    render 'shared/admin/index_page', :layout => 'new_admin', :locals => {
      :items => @items,
      :model => Topic,
      :fields => [:title, :comments_count, :created_at],
      :paginate => true,
      :config => @config
    }
  end

  def new
    @item = Topic.new
    render 'shared/admin/new_page', :layout => 'new_admin', :locals => {
      :item => @item,
      :model => Topic,
      :fields => [:title, :forum_id],
      :associations => { :belongs_to => { :user => :user_id , :forum => :forum_id }  }
    }
  end

  def edit
    @item = Topic.find(params[:id])

    render 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
      :item => @item,
      :model => Topic,
      :fields => [:title],
      :associations => { :belongs_to => { :user => :user_id , :forum => :forum_id }  }
    }
  end

  def update
    @item = Topic.find(params[:id])
    if @item.update_attributes(params[:topic])
      @item.expire
      flash[:success] = "Successfully updated your Topic."
      redirect_to [:admin, @item]
    else
      flash[:error] = "Could not update your Topic as requested. Please try again."
      render 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
        :item => @item,
        :model => Topic,
        :fields => [:title],
        :associations => { :belongs_to => { :user => :user_id , :forum => :forum_id }  }
      }
    end
  end

  def show
    render 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => Topic.find(params[:id]),
      :model => Topic,
      :fields => [:title, :comments_count, :created_at],
    }
  end

  def create
    @item = Topic.new(params[:topic])
    if @item.save
      flash[:success] = "Successfully created your new Topic!"
      redirect_to [:admin, @item]
    else
      flash[:error] = "Could not create your Topic, please try again"
      render 'shared/admin/new_page', :layout => 'new_admin', :locals => {
        :item => @item,
        :model => Topic,
        :fields => [:title, :forum_id],
        :associations => { :belongs_to => { :user => :user_id , :forum => :forum_id }  }
      }
    end
  end

  def destroy
    @item = Topic.find(params[:id])
    @item.destroy

    redirect_to admin_topics_path
  end

  private

  def set_current_tab
    @current_tab = 'topics';
  end

end
