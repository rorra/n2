class Admin::PredictionGroupsController < AdminController

  def index
    meta_search = {:s => "created_at desc"}.merge(params[:q] || {})
    @search = PredictionGroup.search(meta_search)
    @search.build_grouping unless @search.groupings.any?
    @items = @search.result.paginate(:page => params[:page], :per_page => 20)

    render 'shared/admin/index_page', :layout => 'new_admin', :locals => {
      :items => @items,
      :model => PredictionGroup,
      :fields => [:title, :created_at],
      :associations => { :belongs_to => { :user => :user_id } },
      :paginate => true
    }
  end

  def new
    render_new
  end

  def edit
    @prediction_group = PredictionGroup.find(params[:id])

    render_edit @prediction_group
  end

  def update
    @prediction_group = PredictionGroup.find(params[:id])
    if @prediction_group.update_attributes(params[:prediction_group])
      flash[:success] = "Successfully updated your PredictionGroup."
      redirect_to [:admin, @prediction_group]
    else
      flash[:error] = "Could not update your PredictionGroup as requested. Please try again."
      render_edit @prediction_group
    end
  end

  def show
    render 'shared/admin/show_page', :layout => 'new_admin', :locals => {
      :item => PredictionGroup.find(params[:id]),
      :model => PredictionGroup,
      :fields => [:title, :section, :description, :status, :is_approved, :is_blocked, :user_id, :created_at],
      :associations => { :belongs_to => { :user => :user_id } }
    }
  end

  def create
    @prediction_group = PredictionGroup.new(params[:prediction_group])
    @prediction_group.section = @prediction_group.title
    if @prediction_group.save
      flash[:success] = "Successfully created your new PredictionGroup!"
      redirect_to [:admin, @prediction_group]
    else
      flash[:error] = "Could not create your PredictionGroup, please try again"
      render_new @prediction_group
    end
  end

  def destroy
    @prediction_group = PredictionGroup.find(params[:id])
    @prediction_group.destroy

    redirect_to admin_prediction_groups_path
  end

  def approve
    @prediction_group = PredictionGroup.find(params[:id])
    unless @prediction_group
      flash[:error] = "Invalid prediction group"
      redirect_to admin_prediction_groups_path
    end

    if @prediction_group.update_attribute(:is_approved, true)
      flash[:success] = "Successfully approved this topic"
      redirect_to admin_prediction_groups_path
    else
      flash[:error] = "Could not approve this topic"
      redirect_to admin_prediction_groups_path
    end
  end

  private

  def render_new prediction_group = nil
    prediction_group ||= PredictionGroup.new

    render 'shared/admin/new_page', :layout => 'new_admin', :locals => {
      :item => prediction_group,
      :model => PredictionGroup,
      :fields => [:title, lambda {|f| f.input :description, :required => false }, :status, :is_approved, :is_blocked, :user_id],
      :associations => { :belongs_to => { :user => :user_id } }
    }
  end

  def render_edit prediction_group
    render 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
      :item => prediction_group,
      :model => PredictionGroup,
      :fields => [:title, :section,  lambda {|f| f.input :description, :required => false }, :status, :is_approved, :is_blocked, :user_id],
      :associations => { :belongs_to => { :user => :user_id } }
    }
  end

  def set_current_tab
    @current_tab = 'prediction_groups';
  end


end
