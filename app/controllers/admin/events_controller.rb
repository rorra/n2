require 'zvent'
class Admin::EventsController < AdminController

  def index
    meta_search = {:s => "created_at desc"}.merge(params[:q] || {})
    @search = Event.search(meta_search)
    @search.build_grouping unless @search.groupings.any?
    @items = @search.result.paginate(:page => params[:page], :per_page => 20)
    render 'shared/admin/index_page', :layout => 'new_admin', :locals => {
      :items => @items,
      :model => Event,
      :fields => [:name, :user_id, :votes_tally, :comments_count, :created_at],
      :associations => { :belongs_to => { :user => :user_id } },
      :paginate => true
    }
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      @event.expire
      flash[:success] = "Successfully updated your Event ."
      redirect_to [:admin, @event]
    else
      flash[:error] = "Could not update your Event  as requested. Please try again."
      render :edit
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(params[:event])
    @event.user = current_user
    if @event.save
      flash[:success] = "Successfully created your new Event!"
      redirect_to [:admin, @event]
    else
      flash[:error] = "Could not create your Event , please try again"
      render :new
    end
  end

  def import_zvents
    if request.post? and Metadata::Setting.find_setting('zvent_api_key').try(:value) and Metadata::Setting.find_setting('zvent_location').try(:value)
      zvent = Zvent::Session.new(Metadata::Setting.find_setting('zvent_api_key').try(:value))
      zevents = zvent.find_events_by_date('next 30 days', :where => Metadata::Setting.find_setting('zvent_location').try(:value), :limit => 50)
      count = 0
      zevents[:events].each do |event|
        if params[:commit] == "Import Selected Events"
          next unless params[:events].present? and params[:events].any?
          next unless params[:events].include? event.id.to_s
        end
        Event.create_from_zvent_event(event,current_user)
        count += 1
      end
      if count > 0
        flash[:success] = "Successfully added #{count} events!"
      else
        flash[:error] = "Could not add any events, please try again"
      end
      EventSweeper.expire_event_all Event.last
      redirect_to admin_events_path
    else
      if Metadata::Setting.find_setting('zvent_api_key').try(:value) and Metadata::Setting.find_setting('zvent_location').try(:value)
        zvent =Zvent::Session.new(Metadata::Setting.find_setting('zvent_api_key').try(:value))
        zevents = zvent.find_events_by_date('next 30 days', :where => Metadata::Setting.find_setting('zvent_location').try(:value), :limit => 50)
        @events = zevents[:events]
      end
    end
  end

  private

  def set_current_tab
    @current_tab = 'events';
  end

end
