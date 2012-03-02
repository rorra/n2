class Admin::CardsController < AdminController
  before_filter :find_card, :only => [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html do
        search = {"meta_sort" => "name.desc"}.merge(params[:search] || {})
        @search = Card.search(search)
        @cards = @search.paginate(:page => params[:page])
      end
    end
  end

  def show
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(params[:card])

    if @card.save
      flash[:success] = "Successfully created your new Card!"
      redirect_to [:admin, @card]
    else
      flash[:error] = "Could not create your Card, please try again"
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @card.update_attributes(params[:card])
      flash[:success] = "Successfully updated your Card."
      redirect_to [:admin, @card]
    else
      flash[:error] = "Could not update your Card as requested. Please try again."
      render :action => :edit
    end
  end

  def destroy
    if @card.destroy
      flash[:success] = "Successfully deleted your Card."
    else
      flash[:error] = "Could not delete your Card as requested. Please try again."
    end

    redirect_to :action => :index
  end

  private

  def find_card
    @card = Card.find(params[:id])
  end


end
