class ItemAction < ActiveRecord::Base
  belongs_to :user
  belongs_to :actionable, :polymorphic => true

  named_scope :for_item, lambda {|item| { :conditions => ["actionable_type = ? and actionable_id = ?", item.class.name, item.id] } }
  named_scope :for_class, lambda {|item| { :conditions => ["actionable_type = ?", item.name] } }
  named_scope :within, lambda {|timeframe| { :conditions => ["created_at > ?", timeframe] } }
  named_scope :active, { :conditions => {:is_blocked => false} }

  def self.top_items_for_class klass, opts = {}
    self.fetch_items opts.merge({:klass => klass})
  end

  def self.tally_for_item item, opts = {}
    item_actions = self.fetch_items opts.merge({:item => item})

    item_actions ? item_actions.item_count.to_i : 0
  end

  def self.top_items opts = {}
    self.fetch_items opts
  end
  
  def self.fetch_items opts = {}
    options = {
      :limit      => 10,
      :group      => 'actionable_type, actionable_id',
      :conditions => ["action_type != ?", 'facebook_unlike'],
      :select     => '*, COUNT(*) AS item_count',
      :order      => 'item_count desc',
      :item       => nil,
      :klass      => nil,
      :item_count => false,
      :within => 1.week.ago,
      :minimum => 0
    }
    options.merge! opts
    item = options.delete :item
    klass = options.delete :klass
    minimum = options.delete :minimum
    include_item_count = options.delete :item_count
    within = options.delete :within
    amount = item ? :first : :all

    chains = [:active]
    chains << [:for_class, klass] if klass
    chains << [:for_item, item] if item
    chains << [:within, within] if within

    results = self.get_chain_results chains, amount, options
    if results.is_a?(Array) and within and results.size < minimum
      chains.pop # remove :within
      results = self.get_chain_results chains, amount, options # try again
    end
    
    if item
      return results
    else
      results.map do |item|
        include_item_count ? [item.actionable, item.item_count.to_i] : item.actionable
      end
    end
  end

  def self.gen_user_posted_item! user, item, action_type = :posted_item
    ItemAction.create!({
                         :actionable => item,
                         :user => user,
                         :action_type => action_type.to_s
                       })
  end

  def self.get_chain_results chains, amount, options
    results = chains.inject(self) do |chain, scope|
      if scope.is_a? Array
      	chain.send scope[0], scope[1]
      else
      	chain.send scope
      end
    end

    results.find(amount, options)
  end
end
