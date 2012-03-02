class Admin::ClassifiedsController < AdminController
  before_filter :find_classified, :only => [:show]

  def index
    respond_to do |format|
      format.html do
        search = {"meta_sort" => "id.desc"}.merge(params[:search] || {})
        @search = Classified.search(search)
        @classifieds = @search.paginate(:page => params[:page])
      end
    end
  end

  def show
  end

  private

  def find_classified
    @classified = Classified.find(params[:id])
  end
end
