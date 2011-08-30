class Url < ActiveRecord::Base
  has_many :tweet_urls
  has_many :urls, :through => :tweet_urls
  belongs_to :source

  before_validation :set_source, :unless => :source
  validates_presence_of :source

  delegate :allowed_source?, :to => :source

  private

    def set_source
      self.source = Source.find_or_create_from_url url
    end

end
