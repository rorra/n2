class TweetAccount < ActiveRecord::Base
  has_many :tweets
  belongs_to :user

  def self.get_user_from_json user_json
    tweet_account = self.find_by_twitter_id_str(user_json["id_str"])

    unless tweet_account
      user              = User.new
      user.name         = user_json["screen_name"]
      user.twitter_user = true
      user.system_user  = true

      tweet_account = TweetAccount.create!({
        :twitter_id_str    => user_json["id_str"],
        :name              => user_json["name"],
        :screen_name       => user_json["screen_name"],
        :description       => user_json["description"],
        :profile_image_url => user_json["profile_image_url"],
        :user              => user
      })
    end

    tweet_account
  end

  def to_s
    "@#{screen_name}"
  end

end
