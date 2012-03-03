class Admin::FlagsController < AdminController
  before_filter :find_flag, :only => [:show, :destroy]

  def index
    respond_to do |format|
      format.html do
        search = {"meta_sort" => "created_at.desc"}.merge(params[:search] || {})
        @search = Flag.search(search)
        @flags = @search.paginate(:page => params[:page])
      end
    end
  end

  def show
  end

  def destroy
    if @flag.destroy
      flash[:success] = "Successfully deleted your Flag."
    else
      flash[:error] = "Could not delete your Flag as requested. Please try again."
    end

    redirect_to :action => :index
  end

  private

  def find_flag
    @flag = Flag.find(params[:id])
  end  

end
