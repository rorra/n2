class Admin::TweetStreamsController < AdminController
  before_filter :verify_twitter_configured

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

  def verify_twitter_configured
    @oauth_key = Metadata::Setting.find_setting('oauth_key')
    @oauth_secret = Metadata::Setting.find_setting('oauth_secret')
    @oauth_consumer_key = Metadata::Setting.find_setting('oauth_consumer_key')
    @oauth_consumer_secret = Metadata::Setting.find_setting('oauth_consumer_secret')
    @base_consumer_key = 'U6qjcn193333331AuA'
    @base_consumer_secret = 'Heu0GGaRuzn762323gg0qFGWCp923viG8Haw'
    ['key', 'secret', 'consumer_key', 'consumer_secret'].each do |key|
      val = instance_variable_get("@oauth_#{key}").try(:value)
      if not val or val.empty? or val == @base_consumer_key or val == @base_consumer_secret
      	flash[:error] = "You must configure your twitter settings before adding tweet streams."
        redirect_to admin_twitter_settings_path and return
      	break
      end
    end
  end
end
