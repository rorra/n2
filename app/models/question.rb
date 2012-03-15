class Question < ActiveRecord::Base

  acts_as_voteable
  acts_as_taggable_on :tags, :sections
  acts_as_featured_item
  acts_as_moderatable
  acts_as_media_item
  acts_as_refineable
  acts_as_wall_postable
  acts_as_tweetable

  belongs_to  :user
  has_many    :answers

  validates_presence_of :question

  attr_accessor :tags_string

  has_friendly_id :question, :use_slug => true

  scope :top, lambda { |*args| { :order => ["(2*answers_count+votes_tally) desc, created_at desc"], :limit => (args.first || 10)} }
  scope :newest, lambda { |*args| { :order => ["created_at desc"], :limit => (args.first || 10)} }
  scope :unanswered, lambda { |*args| { :conditions => ["answers_count = 0"], :order => ["created_at asc"], :limit => (args.first || 10) } }
  scope :featured, lambda { |*args| { :conditions => ["is_featured=1"],:order => ["created_at desc"], :limit => (args.first || 3)} }

  def self.per_page; 20; end

  def self.get_top
    self.tally({
      :at_least => 1,
      :limit    => 10,
      :order    => "vote_count desc"
    })
  end

  def self.valid_refine_type? value
    ['newest', 'top', 'unanswered'].include? value.downcase
  end

  def self.refineable_select_options
    ['Newest', 'Top', 'Unanswered'].collect { |k| [k, k] }
  end

  def featured_related_count
    self.answers_count
  end

  def featured_related_locale
    'answers_label'
  end

  def item_description
    details.present? ? details : item_title
  end

  def expire
    self.class.sweeper.expire_question_all self
  end

  def self.expire_all
    self.sweeper.expire_question_all self.new
  end

  def self.sweeper
    QandaSweeper
  end

  def action_links
    links = []
    #links << lambda {|klass| vote_link(klass) }
    #links << lambda {|klass| tally_link(klass) }
    #links << lambda {|klass| answer_link(klass) }
    links
  end

  def to_s
    question.size > 26 ? "#{question[0,22]}..." : question
  end

end
