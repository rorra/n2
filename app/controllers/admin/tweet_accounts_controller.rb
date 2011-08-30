class Admin::TweetAccountsController < AdminController

  admin_scaffold :tweet_accounts do |config|
    config.index_fields = [:screen_name, :name, :description]
    config.show_fields = [:screen_name, :name, :description]
    config.associations = { :belongs_to => { :user => :user_id } }
    config.actions = [:index, :show, :edit, :update]
  end

  def fetch_new_tweets
    @tweet_stream = TweetStream.find(params[:id])
    if @tweet_stream.async_update_tweet_stream
      flash[:success] = "Queued your tweet stream for processing. Please wait a few minutes."
      redirect_to admin_tweet_streams_path
    else
      flash[:error] = "Could not process your tweet stream."
      redirect_to admin_tweet_streams_path
    end
  end

end
