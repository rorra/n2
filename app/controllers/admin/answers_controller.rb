class Admin::AnswersController < AdminController
  before_filter :find_answer, :only => [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html do
        search = {"meta_sort" => "id.desc"}.merge(params[:search] || {})
        @search = Answer.search(search)
        @answers = @search.paginate(:page => params[:page])
      end
    end
  end

  def show
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(params[:answer])

    if @answer.save
      flash[:success] = "Successfully created your new Answer!"
      redirect_to admin_answer_path(@answer)
    else
      flash[:error] = "Could not create your Answer, please try again"
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @answer.update_attributes(params[:answer])
      flash[:success] = "Successfully updated your Answer."
      redirect_to admin_answer_path(@answer)
    else
      flash[:error] = "Could not update your Answer as requested. Please try again."
      render :action => :edit
    end
  end

  def destroy
    if @answer.destroy
      flash[:success] = "Successfully deleted your Answer."
    else
      flash[:error] = "Could not delete your Answer as requested. Please try again."
    end

    redirect_to :action => :index
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

end
