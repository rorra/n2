class Admin::TweetStreamsController < AdminController

  admin_scaffold :tweet_stream do |config|
    config.index_fields = [:list_username, :list_name, :description, :tweets_count]
    config.new_fields = [:list_username, :list_name]
    config.edit_fields = [:list_username, :list_name, :description]
    config.show_fields = [:list_username, :list_name, :description, :tweets_count, :created_at, :updated_at]
    config.actions = [:index, :new, :update, :create, :show, :edit]
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
