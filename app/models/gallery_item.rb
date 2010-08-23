class GalleryItem < ActiveRecord::Base
  acts_as_media_item
  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_moderatable
  acts_as_wall_postable
  
  named_scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  named_scope :featured, lambda { |*args| { :conditions => ["is_featured=1"],:order => ["created_at desc"], :limit => (args.first || 3)} }

  belongs_to :user
  belongs_to :gallery
  has_many :comments, :as => :commentable
  has_one :tweeted_item, :as => :item
  attr_accessor :tags_string

  has_friendly_id :title, :use_slug => true

  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :gallery
  validates_format_of :tags_string, :with => /^([-a-zA-Z0-9_ ]+,?)+$/, :allow_blank => true, :message => "Invalid tags. Tags can be alphanumeric characters or -_ or a blank space."  

  def self.per_page; 10; end
  
  def self.top
    self.tally({
    	:at_least => 1,
    	:limit    => 10,
    	:order    => "votes.count desc"
    })
  end

end