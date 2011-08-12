class Url < ActiveRecord::Base
  has_many :tweet_urls
  has_many :urls, :through => :tweet_urls
end
