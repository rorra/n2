class PredictionsController < ApplicationController
  before_filter :logged_in_to_facebook_and_app_authorized, :only => [:my_predictions, :new, :create, :update, :like], :if => :request_comes_from_facebook?
  after_filter :store_location, :only => [:index, :scores, :my_predictions ]

  #cache_sweeper :resource_sweeper, :only => [:create, :update, :destroy]

  before_filter :set_current_tab
  before_filter :set_ad_layout, :only => [:index]
  
  access_control do
    allow all, :to => [:index, :show, :tags, :scores]
    # HACK:: use current_user.is_admin? rather than current_user.has_role?(:admin)
    # FIXME:: get admins switched over to using :admin role
    allow :admin, :of => :current_user
    allow :admin
    allow logged_in, :to => [:new, :create, :my_resources]
    #allow :owner, :of => :model_klass, :to => [:edit, :update]
  end

  def index
    redirect_to play_prediction_groups_path
  end
  
  def scores
    @current_sub_tab = 'Scores'
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @prediction_scores = PredictionScore.top.paginate :page => params[:page], :per_page => PredictionScore.per_page, :order => "accuracy desc"
    respond_to do |format|
      format.html { @paginate = false }
      format.json { @users = User.refine(params) }
    end
  end
  
  def new
  end

  def create
  end

  def my_predictions
    @paginate = true
    @current_sub_tab = 'Yours'
    @prediction_guesses = current_user.prediction_guesses.active.paginate :page => params[:page], :per_page => PredictionGuess.per_page, :order => "created_at desc"
  end

  private
   
  def set_current_tab
    @current_tab = 'predictions'
  end
end
