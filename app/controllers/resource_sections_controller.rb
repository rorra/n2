class ResourceSectionsController < ApplicationController
  before_filter :set_current_tab
  before_filter :set_ad_layout, :only => [:index, :show]
  before_filter :set_meta_klass, :only => [:index]

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
    @current_sub_tab = 'Browse Resource Sections'
    @resource_sections = ResourceSection.active.paginate :page => params[:page], :per_page => 10, :order => "created_at desc"
  end

  def show
    @current_sub_tab = 'Browse Section Resources'
    @resource_section = ResourceSection.active.find(params[:id])
    @top_resources = @resource_section.resources.active.tally({
      :at_least => 1,
      :limit    => 5,
      :order    => "vote_count desc"
    })
    @newest_resources = @resource_section.resources.active.newest 5
    set_sponsor_zone('resources', @resource_section.item_title.underscore)
    set_current_meta_item @resource_section
  end

  private

  def set_current_tab
    @current_tab = 'resources'
  end

  def set_meta_klass
    set_current_meta_klass ResourceSection
  end

end
