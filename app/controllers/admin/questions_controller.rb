class Admin::QuestionsController < AdminController
  before_filter :find_question, :only => [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html do
        search = {"meta_sort" => "id.desc"}.merge(params[:search] || {})
        @search = Question.search(search)
        @questions = @search.paginate(:page => params[:page])
      end
    end
  end

  def show
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(params[:question])

    if @question.save
      flash[:success] = "Successfully created your new Question!"
      redirect_to admin_question_path(@question)
    else
      flash[:error] = "Could not create your Question, please try again"
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @question.update_attributes(params[:question])
      flash[:success] = "Successfully updated your Question."
      redirect_to admin_question_path(@question)
    else
      flash[:error] = "Could not update your Question as requested. Please try again."
      render :action => :edit
    end
  end

  def destroy
    if @question.destroy
      flash[:success] = "Successfully deleted your Question."
    else
      flash[:error] = "Could not delete your Question as requested. Please try again."
    end

    redirect_to :action => :index
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

end
