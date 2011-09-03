class Source < ActiveRecord::Base
  acts_as_moderatable


  validates_presence_of :name
  validates_presence_of :url
  validates_uniqueness_of :url
  validates_format_of :url, :with => /\A(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i, :message => "should look like a URL", :allow_blank => false
  before_validation :extract_host

  validate :validate_filter_type

  named_scope :white_listed, :condition => { :white_list => true, :black_list => false }
  named_scope :black_listed, :condition => { :white_list => false, :black_list => true }

  has_many :contents
  has_many :audios
  has_many :images
  has_many :videos
  has_many :urls

  def allowed_source?
    if self.class.white_list_enabled?
      white_list?
    elsif black_list?
      false
    else
      true
    end
  end

  def self.white_list_enabled?
    setting = Metadata::Setting.get('enable_whitelist','tweet_streams')
    setting ? setting.value : true
  end

  def self.find_or_create_from_url url_str
    uri = URI.parse(url_str)
    source = Source.find_by_url(uri.host)

    unless source
      source = Source.create!({
        :url => uri.host,
        :name => uri.host
      })
    end

    source
  end

  private
    
    def validate_filter_type
      if white_list? and black_list?
        [:white_list, :black_list].each do |list_type|
          errors.add(list_type, "You may only white list or black list a source, not both. Please choose one.")
        end
      end
    end

    def extract_host
      host_uri = URI.parse(self.url)

      if host_uri.host
        self.url = host_uri.host
      end
    end
  
end
