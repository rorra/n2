class Admin::SourcesController < AdminController

  admin_scaffold :sources do |config|
    config.index_fields = [:name, :url, :white_list, :black_list, :all_subdomains_valid, :created_at]
    config.new_fields = [:name, :url, :white_list, :black_list, :all_subdomains_valid]
    config.edit_fields = [:name, :url, :white_list, :black_list, :all_subdomains_valid]
    config.show_fields = [:name, :url, :white_list, :black_list, :all_subdomains_valid]
    config.actions = [:index, :new, :update, :create, :show, :edit]
  end

  private

    def set_current_tab
      @current_tab = 'sources';
    end

end
