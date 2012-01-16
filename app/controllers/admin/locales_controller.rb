class Admin::LocalesController < AdminController
  def index
    @locales = I18n::Backend::Locale.find(:all)
  end

  def show
    @locale = I18n::Backend::Locale.find_by_code(params[:id])
  end

  def new
    @locale = I18n::Backend::Locale.new
  end

  def edit
    @locale = I18n::Backend::Locale.find_by_code(params[:id])
  end

  def create
    @locale = I18n::Backend::Locale.new(params[:locale_form])

    if @locale.save
      flash[:notice] = 'Locale was successfully created.'
      redirect_to [:admin, @locale]
    else
      render :action => "new"
    end
  end

  def update
    @locale = I18n::Backend::Locale.find_by_code(params[:id])
    if @locale.update_attributes(params[:locale_form])
      flash[:notice] = 'Locale was successfully updated.'
      redirect_to admin_locale_path(@locale)
    else
      render :action => "edit"
    end
  end

  def destroy
    @locale = I18n::Backend::Locale.find_by_code(params[:id])
    @locale.destroy
    redirect_to admin_locales_path
  end

  def refresh
    # TODO:: HACK:: OMFG:: GET RID OF THIS!!!!!!! but how?
    # There isn't a way to clear a namespace in memcached
    # There isn't a default expiry option for rails memcached
    # There is not a pleasant way to clear all cached items,
    # including stories/ideas/whatever, have to manually iterate over them
    # This is a serious issue that needs to be addressed
    # Cached fragments depend on locales and need to be invalidated with the locales
    # but how? doing a flush_all is a terrible solution.
    Newscloud::Redcloud.expire_views
    Newscloud::Redcloud.expire_locales
    flash[:success] = "Refreshed locales"
    redirect_to admin_locales_path
  end
end
