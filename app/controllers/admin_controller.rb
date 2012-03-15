class AdminController < ApplicationController
  layout proc { |c| c.request.xhr? ? false : "new_admin" }

  #before_filter :check_admin_or_default_status
  before_filter :set_current_tab
  before_filter :check_iframe

  self.class_eval do
    # TODO::
    #   - finish methods
    #   - add associations to edit/new forms
    #   - dynamically find associations
    #   - add association lists to show page
    #   - add mixin logic
    #   - add action links
    #   - only show new links if actions.include? :new
    #   - add related links
    #   - add return links
    #   - switch to allowing model_id or hash options
    def self.admin_scaffold_build_config model_id = nil
      # switch to calling methods in context of admin_scaffold_config object
      @config = OpenStruct.new
      @config.model_id = model_id
      @config.klass_name = self.to_s.split('::').last.sub(/Controller$/, '')
      @config.model_klass = @config.model_id.to_s.classify.constantize
      @config.actions = [:index, :show, :new, :create, :edit, :update, :destroy]
      @config.fields = @config.model_klass.columns
      @config.form_name = @config.model_klass.name.underscore
      @config.model_title = @config.model_klass.name.titleize
      @config.paginate = true
      @config.media_form = false
      @config.associations = {}
      @config.edit_fields = @config.fields.select { |f| not (f.name =~ /_at$/ or f.name == 'id' or f.name =~ /tally|count$/) }.map(&:name)
      @config.new_fields = @config.fields.select { |f| not (f.name =~ /_at$/ or f.name == 'id' or f.name =~ /tally|count$/) }.map(&:name)
      @config
    end

    def self.admin_scaffold(model_id = nil, &block)
      raise ArgumentError.new("Must provide model_id or config block") unless model_id.present? or block_given?

      cattr_accessor :admin_scaffold_config
      self.admin_scaffold_build_config model_id

      yield @config if block_given?

      @config.actions.each do |action|
        define_method action do
          case action
            when :index
              @config = self.admin_scaffold_config
              if @config.extra_scopes and @config.extra_scopes.any?
                @search = @config.model_klass.send(@config.extra_scopes.first).search(params[:q])
              else
                @search = @config.model_klass.search(params[:q])
              end
              @search.build_grouping unless @search.groupings.any?
              @items = @search.result.paginate(:page => params[:page], :per_page => 20)
              render 'shared/admin/index_page', :layout => 'new_admin', :locals => {
                # TODO:: handle active
                #:items        => @config.model_klass.active.paginate(:page           => params[:page], :per_page => 20, :order => "created_at desc"),
                :items => @items,
                :model => @config.model_klass,
                :fields => @config.index_fields || @config.fields.map(&:name),
                :associations => @config.associations,
                :paginate => @config.paginate,
                :config => @config
              }
            when :show
              @config = self.admin_scaffold_config
              render 'shared/admin/show_page', :layout => 'new_admin', :locals => {
                :item => @config.model_klass.find(params[:id]),
                :model => @config.model_klass,
                :associations => @config.associations,
                :fields => @config.show_fields || @config.fields.map(&:name),
                :config => @config
              }
            when :new
              @config = self.admin_scaffold_config
              render 'shared/admin/new_page', :layout => 'new_admin', :locals => {
                :item => @config.model_klass.new,
                :include_media_form => @config.media_form,
                :model => @config.model_klass,
                :associations => @config.associations,
                :fields => @config.new_fields || @config.new_fields.map(&:name),
                :config => @config
              }
            when :create
              @config = self.admin_scaffold_config
              @item = @config.model_klass.new(params[@config.form_name])
              if @item.save
                flash[:success] = "Successfully created your new #{@config.model_title}"
                redirect_to [:admin, @item]
              else
                flash[:error] = "Please clear any errors and try again"
                render 'shared/admin/new_page', :layout => 'new_admin', :locals => {
                  :item => @item,
                  :include_media_form => @config.media_form,
                  :model => @config.model_klass,
                  :associations => @config.associations,
                  :fields => @config.new_fields || @config.new_fields.map(&:name),
                  :config => @config
                }
              end
            when :edit
              @config = self.admin_scaffold_config
              render 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
                :item => @config.model_klass.find(params[:id]),
                :model => @config.model_klass,
                :include_media_form => @config.media_form,
                :associations => @config.associations,
                :fields => @config.edit_fields || @config.edit_fields.map(&:name),
                :config => @config
              }
            when :update
              @config = self.admin_scaffold_config
              @item = @config.model_klass.find(params[:id])
              if @item.update_attributes(params[@config.form_name])
                flash[:success] = "Successfully updated your #{@config.model_title}"
                redirect_to [:admin, @item]
              else
                flash[:error] = "Please clear any errors and try again"
                render 'shared/admin/edit_page', :layout => 'new_admin', :locals => {
                  :item => @item,
                  :include_media_form => @config.media_form,
                  :model => @config.model_klass,
                  :associations => @config.associations,
                  :fields => @config.edit_fields || @config.edit_fields.map(&:name),
                  :config => @config
                }
              end
            else
              render :text => "Implement: #{action}", :layout => 'new_admin'
          end
        end
      end

      self.admin_scaffold_config = @config
    end

    def self.admin_action
      raise self.action_name.inspect
    end
  end

  def index
    # Loads dashboard
    check_dashboard_settings
    @setting_groups = Newscloud::SettingGroups.groups
  end

  def search
    index
    #render :action => :index
  end

  private

  def set_current_tab
    @current_tab = 'dashboard'
  end

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

  def check_iframe
    if @iframe_status
      @iframe_status = false
      redirect_to admin_path and return false
    end
  end

  def check_dashboard_settings
    @enabled_configs = {}
    @enabled_configs[:automated_feeds] = Feed.count == 0
    google_search_engine_id = get_setting('google_search_engine_id')
    @enabled_configs[:google_search_engine] = google_search_engine_id.present? && google_search_engine_id.value == "your-google-search-engine-id"
    google_site_verification = get_setting('google-site-verification')
    @enabled_configs[:google_sitemap] = google_site_verification.present? && google_site_verification.value == 'WS8kMC8-Ds77777777777Xy6QcmRpWAfY'
    google_analytics_site_id = get_setting('google_analytics_site_id')
    google_analytics_account_id = get_setting('google_analytics_account_id')
    @enabled_configs[:google_analytics] = (google_analytics_account_id.present? && google_analytics_account_id.value=='UF-123456890-7') || (google_analytics_site_id.present? && google_analytics_site_id.value=='1231232')
    bitly_username = get_setting('bitly_username')
    bitly_api_key = get_setting('bitly_api_key')
    @enabled_configs[:bitly] = (bitly_username.present? && bitly_username.value =='username') || (bitly_api_key.present? && bitly_api_key.value=='api_key')
    account_setting = get_setting('account')
    oauth_key_setting = get_setting('oauth_key')
    @enabled_configs[:twitter] = (account_setting.present? && account_setting.value == 'userkey_name') || (oauth_key_setting.present? && oauth_key_setting.value == 'U6qjcn193333331AuA')
    @enabled_configs[:welcome_panel] = (t('shared.sidebar.welcome_panel.welcome_panel_headline') == "Welcome to our site") || (t('shared.sidebar.welcome_panel.welcome_panel_message_fbml')=="This is such a wonderful community to keep up on local events. We hope you enjoy yourself here.")
    # TODO check for site_notification_user
    site_title = get_setting('site_title')
    site_topic = get_setting('site_topic')
    contact_us_recipient = get_setting('contact_us_recipient')
    app_id = get_setting('app_id')
    @enabled_configs[:basic_site_settings] = (site_title.present? && site_title.value == 'Default Site Title') || (site_topic.present? && site_topic.value == 'Default Topic') || (app_id.present? && app_id.value == '111111111111') || (contact_us_recipient.present? && contact_us_recipient.value == 'admin@email.com,me@email.com,support@email.com')
    @enabled_configs[:user_admins] = !User.admins.any?
  end

end
