class MenuItem < ActiveRecord::Base
  acts_as_tree

  named_scope :root_items, :conditions => { :parent_id => nil }
  named_scope :positioned, :order => "position asc"
  named_scope :enabled, :conditions => { :enabled => true }

  def root?
    self.parent_id.nil?
  end

end
