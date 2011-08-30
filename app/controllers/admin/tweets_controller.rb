class Admin::TweetsController < AdminController

  admin_scaffold :tweets do |config|
    config.index_fields = [:tweet_account_id, :tweet_stream_id, :text]
    config.show_fields = [:tweet_account_id, :tweet_stream_id, :text]
    config.associations = { :belongs_to => { :tweet_account => :tweet_account_id, :tweet_stream => :tweet_stream_id } }
    config.actions = [:index, :show]
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
