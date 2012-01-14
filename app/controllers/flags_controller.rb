class FlagsController < ApplicationController

  access_control do
    # HACK:: use current_user.is_admin? rather than current_user.has_role?(:admin)
    # FIXME:: get admins switched over to using :admin role
    allow :admin, :of => :current_user
    allow :moderator, :of => :current_user, :to => [:feature]
    allow :admin
    allow logged_in, :to => [:create]
    #allow :owner, :of => :model_klass, :to => [:edit, :update]
  end

  def create
    @flaggable = find_moderatable_item
    respond_to do |format|
      if @flaggable.flag_item params[:flag_type], current_user
         success = "Thanks. We'll review shortly."
        format.html { flash[:success] = success; redirect_to @flaggable.item_link }
        format.json { render :json => { :msg => success }.to_json }
      else
        error = "Failed to record flag"
        format.html { flash[:error] = error; redirect_to @flaggable.item_link }
        format.json { render :json => { :msg => error }.to_json }
      end
    end
    # TODO:: change this to work with polymorphic associations, switch to using touch
    #expire_page :controller => 'stories', :action => 'show', :id => @story
  end

  def block
    @item = find_moderatable_item
    if @item.moderatable? and @item.blockable? and @item.toggle_blocked
      @item.expire
      # todo - if block user, then use fb:ban api call too! or unban
      flash[:success] = "Successfully #{@item.blocked? ? "Blocked" : "UnBlocked"} your item."
      #redirect_to @item.item_link
      redirect_to root_url
    else
      flash[:error] = "Could not block this item."
      redirect_to @item.item_link
    end
  end

  def feature
    @item = find_moderatable_item
    if @item.moderatable? and @item.featurable? and @item.toggle_featured
      flash[:success] = "Successfully #{@item.featured? ? "Featured" : "UnFeatured"} your item."
      redirect_to @item
    else
      flash[:error] = "Could not feature this item."
      redirect_to @item.item_link
    end
  end

  private

  def find_moderatable_item
    params.each do |name, value|
      next if name =~ /^fb/
      if name =~ /(.+)_id$/
        # switch story requests to use the content model
        klass = $1 == 'story' ? 'content' : $1
        return klass.classify.constantize.find(value)
      end
    end
    nil
  end

end
