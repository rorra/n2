class ForumsController < ApplicationController
  before_filter :set_current_tab
  before_filter :set_ad_layout, :only => [:index, :show]
  before_filter :set_meta_klass, :only => [:index]

  def index
    @forums = Forum.active.positioned
    set_sponsor_zone('forums')
  end

  def show
    @page = params[:page].present? ? (params[:page].to_i < 3 ? "page_#{params[:page]}_" : "") : "page_1_"
    @forum = Forum.active.find(params[:id])
    @topics = @forum.topics.active.paginate :page => params[:page], :per_page => Topic.per_page, :order => "created_at desc"
    @paginate = true
    set_sponsor_zone('forums', @forum.item_title.underscore)
    set_current_meta_item @forum
  end

  private

  def set_current_tab
    @current_tab = 'forums'
  end

  def set_meta_klass
    set_current_meta_klass Forum
  end

end
