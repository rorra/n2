class EventsController < ApplicationController
  before_filter :logged_in_to_facebook_and_app_authorized, :only => [:new, :create, :update, :like], :if => :request_comes_from_facebook?
  before_filter :set_meta_klass, :only => [:index]

  cache_sweeper :event_sweeper, :only => [:create, :update, :destroy, :import_facebook]

  before_filter :set_current_tab
  before_filter :set_ad_layout, :only => [:index, :show, :my_events, :import_facebook]
  before_filter :set_custom_sidebar_widget, :only => [:index, :new, :show, :my_events, :import_facebook]

  access_control do
    allow all, :to => [:index, :show, :tags]
    # HACK:: use current_user.is_admin? rather than current_user.has_role?(:admin)
    # FIXME:: get admins switched over to using :admin role
    allow :admin, :of => :current_user
    allow :admin
    allow logged_in, :to => [:new, :create, :my_events, :import_facebook]
    #allow :owner, :of => :model_klass, :to => [:edit, :update]
  end

  def index
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @current_sub_tab = 'Browse Events'
    @events = Event.active.upcoming.paginate :page => params[:page], :per_page => Event.per_page
    set_sponsor_zone('events')
    respond_to do |format|
      format.html { @paginate = true }
      format.atom
      format.json { @events = Event.refine(params) }
    end
  end

  def new
    @current_sub_tab = 'Suggest Event'
    @event = Event.new
    @events = Event.active.newest
  end

  def create
    @event = Event.new(params[:event])
    @event.tag_list = params[:event][:tags_string]
    @event.user = current_user

    if @event.valid? and current_user.events.push @event
      if @event.post_wall?
        session[:post_wall] = @event
      end
      flash[:success] = "Thank you for your event!"
      redirect_to @event
    else
      flash[:error] = "Could not create your event. Please clear the errors and try again."
      render :new
    end
  end

  def show
    @event = Event.active.find(params[:id])
    tag_cloud @event
    set_sponsor_zone('events', @event.item_title.underscore)
    set_outbrain_item @event
    set_current_meta_item @event
  end

  def my_events
    @paginate = true
    @current_sub_tab = 'My Events'
    @user = User.active.find(params[:id])
    @events = @user.events.active.paginate :page => params[:page], :per_page => Event.per_page, :order => "created_at desc"
  end

  def import_facebook
    if request.post?
      @events = current_facebook_graph_user.events.collect{ |e| params[:fb_events].detect { |myid| myid == e.id}.nil? ? nil : e }.compact
      @events.each do |event|
        Event.create_from_facebook_event(event,current_user)
      end
      flash[:succes] = "Your events have successfully been imported."
      redirect_to events_path
    else
      if current_facebook_graph_user
        @events_allowed = current_facebook_graph_user.has_permission?(:user_events)
        @event = Event.new
        @fb_events = current_facebook_graph_user.events
        @fb_events.delete_if {|x| !x.start_time.nil?  and (Time.parse(x.start_time) < Time.now)}
        current_events = Event.active.find(:all, :conditions=>["eid IN (?)", @fb_events.collect { |e| e.id }]).collect { |e| e.eid }
        @fb_events.delete_if {|x| current_events.include? x.id.to_s }
      else
        flash[:info] = "You need to connect via Facebook."
        redirect_to events_path
      end
    end
  end

  def tags
    tag_name = CGI.unescape(params[:tag])
    @paginate = true
    @events = Event.active.tagged_with(tag_name, :on => 'tags').paginate :page => params[:page], :per_page => 20, :order => "created_at desc"
    render :template => 'events/index'
  end

  private

  def set_current_tab
    @current_tab = 'events'
  end

  def set_meta_klass
    set_current_meta_klass Event
  end

end
