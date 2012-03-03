class Admin::ContentsController < AdminController
  cache_sweeper :story_sweeper, :only => [:create, :update, :destroy]

  before_filter :find_content, :only => [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html do
        search = {"meta_sort" => "created_at.desc"}.merge(params[:search] || {})
        @search = Content.search(search)
        @contents = @search.paginate(:page => params[:page])
      end
    end
  end
      #:fields => [:title, :user_id, :score, :comments_count, :is_blocked, :created_at],
      #:associations => { :belongs_to => { :user => :user_id, :source => :source } },

  def show
  end

  def new
    @content = Content.new
  end

  def create
    @content = Content.new(params[:content])
    @content
    if @content.save
      flash[:success] = "Successfully created your new Content!"
      redirect_to admin_content_path(@content)
    else
      flash[:error] = "Could not create your Content, please try again"
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @content.update_attributes(params[:content])
      flash[:success] = "Successfully updated your Content."
      redirect_to admin_content_path(@content)
    else
      flash[:error] = "Could not update your Content as requested. Please try again."
      render :action => :edit
    end
  end

  # Show
  #:fields => [:title, :user_id, :url, :caption, :content_image, :source, :score, :comments_count, :is_blocked, :created_at],
  # :associations => { :belongs_to => { :user => :user_id , :source => :source}, :has_one => { :content_image => :content_image} },

  # Edit
  #:fields => [:title, :user_id, :url, :caption, :source, :score, :comments_count, :is_blocked, :created_at],
  #:associations => { :belongs_to => { :user => :user_id , :source => :source}, :has_one => { :content_image => :content_image} },

  def destroy
    if @content.destroy
      flash[:success] = "Successfully deleted your Content."
    else
      flash[:error] = "Could not delete your Content as requested. Please try again."
    end

    redirect_to :action => :index
  end

  private

  def find_content
    @content = Content.find(params[:id])
  end

end
