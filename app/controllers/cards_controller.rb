class CardsController < ApplicationController

  access_control do
    allow anonymous, :to => [:received]
    allow :admin, :of => :current_user
    allow :admin
    allow logged_in, :to => [:show, :post_sent, :get_card_form, :my_received, :my_sent, :received]
    #allow :owner, :of => :model_klass, :to => [:edit, :update]
  end

  def index
    @current_sub_tab = 'Send a Card'
    @cards = Card.active.all.reverse
  end

  def show
    @current_sub_tab = 'Send a Card'
    @card = Card.active.find(params[:id])
  end

  def post_sent
    @card = Card.active.find(params[:id])
    @received_users = params[:ids]
    @success_list = []
    @received_users.each do |ruser_id|
      @success_list << ruser_id if SentCard.create({
      	:card => @card,
      	:from_user => current_user,
      	:to_fb_user_id => ruser_id,
      })
    end
    if @success_list.size > 0
    	CardSweeper.expire_card_all @card
      flash[:success] = t('cards.flash_success')
      redirect_to cards_path
    else
    	flash[:error] = t('cards.flash_error')
      redirect_to cards_path
    end
  end

  def get_card_form
    @card = Card.active.find(params[:id])
  end

  def my_received
    @paginate = true
    @current_sub_tab = 'Cards Received'
    @my_cards = current_user.received_cards.paginate :page => params[:page], :order => "created_at desc"
  end

  def my_sent
    @current_sub_tab = 'Cards Sent'
    @paginate = true
    @my_cards = current_user.sent_cards.paginate :page => params[:page], :order => "created_at desc"
  end

  def received
    @current_sub_tab = 'Cards Received'
    @sender = User.active.find(params[:user_id])
    @card = Card.active.find(params[:card_id])
    @fb_user_id = current_facebook_user.uid
    @sent_card = SentCard.active.find_by_card_id_and_from_user_id_and_to_fb_user_id params[:card_id], @sender.id, @fb_user_id
  end

  private

  def set_current_tab
    @current_tab = 'cards'
  end

end
