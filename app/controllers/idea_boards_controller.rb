class IdeaBoardsController < ApplicationController
  before_filter :set_current_tab
  before_filter :set_ad_layout, :only => [:index, :show]
  before_filter :set_meta_klass, :only => [:index]
  
  access_control do
    allow all, :to => [:index, :show, :tags]
    # HACK:: use current_user.is_admin? rather than current_user.has_role?(:admin)
    # FIXME:: get admins switched over to using :admin role
    allow :admin, :of => :current_user
    allow :admin
    allow logged_in, :to => [:new, :create, :my_resources]
    #allow :owner, :of => :model_klass, :to => [:edit, :update]
  end

  def index
    @current_sub_tab = 'Browse Idea Topics'
    @idea_boards = IdeaBoard.active.paginate :page => params[:page], :per_page => 10, :order => "created_at desc"
  end

  def show
    @current_sub_tab = 'Browse Board Ideas'
    @paginate = true
    @idea_board = IdeaBoard.active.find(params[:id])
    @ideas = @idea_board.ideas.active.paginate :page => params[:page], :per_page => 10, :order => "created_at desc"
    set_sponsor_zone('ideas', @idea_board.item_title.underscore)
    set_current_meta_item @idea_board
  end

  private

  def set_current_tab
    @current_tab = 'ideas'
  end

  def set_meta_klass
    set_current_meta_klass IdeaBoard
  end

end
