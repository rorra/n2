class Mobile::StoriesController < ApplicationController
  layout proc{ |c| c.request.xhr? ? false : "mobile" }

  before_filter :set_current_tab

    
  access_control do
    allow all, :to => [:index, :show, :tags]
    # HACK:: use current_user.is_admin? rather than current_user.has_role?(:admin)
    # FIXME:: get admins switched over to using :admin role
    allow :admin, :of => :current_user
    allow :admin
    allow logged_in, :to => [:new, :create]
    #allow :owner, :of => :model_klass, :to => [:edit, :update]
  end


  def index
    @contents = Content.find(:all, :limit => 10, :order => "created_at desc")
  end

  def show
    @story = Content.find(params[:id])
  end

  def new
    @story = Content.new
  end

  def create
    @story = Content.new(params[:content])
    @story.user = current_user
    if params[:content][:image_url].present?
      @story.build_content_image({:url => params[:content][:image_url]})
    end
    if @story.save
      flash[:success] = "Successfully posted your story!"
      redirect_to story_path(@story)
    else
    	flash[:error] = @story.errors.full_messages
    	render :new
    end
  end

  def like
    @story = Content.find(params[:id])
    if current_user and @story.present?
      current_user.vote_for(@story)
    end

    redirect_to params[:return_to] || stories_path
  end

  private

  def set_current_tab
    @current_tab = 'stories'
  end

end
