class Admin::IdeaBoardsController < AdminController

  def index
    meta_search = {:s => "created_at desc"}.merge(params[:q] || {})
    @search = IdeaBoard.search(meta_search)
    @search.build_grouping unless @search.groupings.any?
    @items = @search.result.paginate(:page => params[:page], :per_page => 20)

    render 'shared/admin/index_page', :layout => 'new_admin', :locals => {
      :items => @items,
      :model => IdeaBoard,
      :fields => [:name, :description, :section],
      :associations => { :belongs_to => {:user => :user_id, :idea_board => :idea_board_id} },
      :paginate => true
    }
  end

  def new
    @idea_board = IdeaBoard.new
  end

  def edit
    @idea_board = IdeaBoard.find(params[:id])
  end

  def update
    @idea_board = IdeaBoard.find(params[:id])
    if @idea_board.update_attributes(params[:idea_board])
      flash[:success] = "Successfully updated your Idea Topic."
      redirect_to [:admin, @idea_board]
    else
      flash[:error] = "Could not update your Idea Topic as requested. Please try again."
      render :edit
    end
  end

  def show
    @idea_board = IdeaBoard.find(params[:id])
  end

  def create
    @idea_board = IdeaBoard.new(params[:idea_board])
    if @idea_board.save
      flash[:success] = "Successfully created your new Idea Topic!"
      redirect_to [:admin, @idea_board]
    else
      flash[:error] = "Could not create your Idea Topic, please try again"
      render :new
    end
  end

  def destroy
    @idea_board = IdeaBoard.find(params[:id])
    @idea_board.destroy
    redirect_to admin_idea_boards_path
  end

  private

  def set_current_tab
    @current_tab = 'idea-boards';
  end

end
