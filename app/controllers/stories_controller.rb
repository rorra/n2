class StoriesController < ApplicationController
  #caches_page :show, :index
  before_filter :logged_in_to_facebook_and_app_authorized, :only => [ :new, :create, :update, :like], :if => :request_comes_from_facebook?

  cache_sweeper :story_sweeper, :only => [:create, :update, :destroy, :like]

  before_filter :set_current_tab
  before_filter :set_meta_klass, :only => [:index]
  before_filter :set_ad_layout, :only => [:index, :show]
  before_filter :set_custom_sidebar_widget, :only => [:index, :show]

  access_control do
    allow all, :to => [:index, :show, :tags, :parse_page]
    # HACK:: use current_user.is_admin? rather than current_user.has_role?(:admin)
    # FIXME:: get admins switched over to using :admin role
    allow :admin, :of => :current_user
    allow :admin
    allow logged_in, :to => [:new, :create]
    #allow :owner, :of => :model_klass, :to => [:edit, :update]
  end

  def index
    page_title :klass => Content
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @current_sub_tab = 'Browse Stories'
    if get_setting('exclude_articles_from_news').try(:value)
      @contents = Content.active.top_story_items.paginate :page => params[:page], :per_page => Content.per_page, :order => "created_at desc"
    else
      @contents = Content.active.top_items.paginate :page => params[:page], :per_page => Content.per_page, :order => "created_at desc"
    end
    respond_to do |format|
      format.html { @paginate = true }
      format.atom
      format.json { @stories = Content.refine(params) }
    end
  end

  def show
    begin
      @story = Content.active.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to stories_path and return unless @story
    else
      # allow only authors and moderators to preview draft articles
      redirect_to root_url and return if @story.is_article? and @story.article.is_draft? and (!current_user.present? or current_user != @story.article.author or !current_user.is_moderator? )
      redirect_to stories_path and return if @story.is_blocked?
    end

    tag_cloud (@story.is_article? ? @story.article : @story)
    if MENU.key? 'articles'
      if @story.is_article?
        @current_tab = 'articles'
        set_sponsor_zone('articles', @story.article.item_title.underscore)
      end
    end
    set_outbrain_item @story
    set_current_meta_item @story
  end

  def new
   if current_user.present? and !current_user.is_moderator? and get_setting('limit_daily_member_posts').present? and get_setting('limit_daily_member_posts').value.to_i <= current_user.count_daily_posts
      flash[:error] = t('error_daily_post_limit')
      redirect_to root_url
   end
   @current_sub_tab = 'New Story'
   @title_filters = Metadata::TitleFilter.all.map(&:keyword)
   if params[:u].present?
      title = params[:t]
      title = @title_filters.inject(title) {|str,key| str.gsub(%r{#{key}}, '') }
      title.sub(/^[|\s]+/,'').sub(/[|\s]+$/,'')
      @story = Content.new({
        :url      => params[:u],
        :title    => title,
        :caption  => params[:c]
      })
    elsif params[:newswire_id].present?
      @newswire = Newswire.active.find(params[:newswire_id])
      title = @newswire.title
      title = @title_filters.inject(title) {|str,key| str.gsub(%r{#{key}}, '') }
      title.sub(/^[|\s]+/,'').sub(/[|\s]+$/,'')
      @story = Content.new({
        :url      => @newswire.url,
        :title    => title,
        :caption  => @template.strip_tags(@newswire.caption),
        :newswire => @newswire
      })
    else
      @story = Content.new
    end
  end

  def create
    @story = Content.new(params[:content])
    @story.tag_list = params[:content][:tags_string]
    @story.caption = view_context.sanitize_user_content @story.caption
    @story.user = current_user
    if @story.valid? and current_user.contents.push @story
      if @story.post_wall?
        session[:post_wall] = @story
      end
      if get_setting('tweet_all_moderator_items').try(:value)
        if current_user.present? and current_user.is_moderator?
          @story.tweet
        end
      end
      flash[:success] = "Successfully posted your story!"
      redirect_to story_path(@story)
    else
      flash[:error] = "Could not create your story. Please clear the errors and try again."
      render :new
    end
  end

  def parse_page
    @url = params[:url]
    error = nil
    begin
      @page_data = Parse::Page.parse_page(@url) unless @url.empty?
    rescue
      error = true
    end
    respond_to do |format|
      if error
        format.html { render :text => @page_data }
        format.json { render :json => {:error => "Could not parse url, try a different url"}.to_json, :status => 400 }
      else
        format.html { render :text => @page_data }
        format.json { render :json => @page_data.to_json, :status => 200 }
      end
    end
  end

  def tags
    tag_name = CGI.unescape(params[:tag])
    @paginate = true
    @contents = Content.active.tagged_with(tag_name, :on => 'tags').paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
  end

  private

  def set_current_tab
    @current_tab = 'stories'
  end

  def set_meta_klass
    set_current_meta_klass Content
  end

end
