# Based on reddit scoring algorithm
# Heavily borrowed from: http://amix.dk/blog/post/19588
# Algorithm: http://amix.dk/uploads/reddit_cf_algorithm.png

class ItemScore < ActiveRecord::Base

  IMAGE_SCALING_FACTOR = 1.1

  belongs_to :scorable, :polymorphic => true

  scope :for_item, lambda {|item| { :conditions => ["scorable_type = ? and scorable_id = ?", item.class.name, item.id] } }
  scope :for_class, lambda {|item| { :conditions => ["scorable_type = ?", item.name] } }
  scope :active, { :conditions => {:is_blocked => false} }
  scope :top, lambda { |*args| { :order => ["score desc"], :limit => (args.first || 5)} }

  def self.top_items limit = nil
    active.top(limit).map(&:scorable)
  end

  def self.score_count ups, downs
    ups - downs
  end

  def self.get_score item
    self.find_or_create(item).score
  end

  def self.calc_item_score item
    positive_actions_count = ItemAction.tally_for_item(item) + 1
    negative_actions_count = 0 # Eventually change this

    votes_score = self.score_count(positive_actions_count, negative_actions_count)
    order = Math.log10([votes_score.abs, 1].max)
    sign = votes_score > 0 ? 1 : votes_score.zero? ? 0 : -1

    seconds =
      if item.respond_to?(:created_at)
        item.created_at.to_i - 1134028003
      else
        1
      end

    score = (order + sign * seconds / 45000).round(7)

    score *= IMAGE_SCALING_FACTOR if item.media_item? and item.images.any?

    {
      :score                  => score,
      :positive_actions_count => positive_actions_count,
      :negative_actions_count => negative_actions_count
    }
  end

  def self.find_or_create item
    self.for_item(item).first || self.create_from_item!(item)
  end

  def self.find_or_create_and_score item
    item_score = find_or_create item
    item_score.update_score!
    item_score
  end

  def update_score!
    update_attributes self.class.calc_item_score(self.scorable)
  end

  def self.rebuild_scores klass = nil
    klasses = klass.nil? ? rankable_classes : [klass]

    klasses.each do |klass|
      puts "Rebuilding scores for #{klass.name.tableize.titleize}"
      (klass.respond_to?(:active) ? klass.active : klass).find_each(:batch_size => 200) do |item|
        find_or_create_and_score(item)
      end
    end
  end

  private

  def self.create_from_item! item
    ItemScore.create!(:scorable => item)
  end
end
