class MenuItem < ActiveRecord::Base
  acts_as_tree

  scope :root_items, :conditions => { :parent_id => nil }
  scope :positioned, :order => "position asc"
  scope :enabled, :conditions => { :enabled => true }

  def root?
    self.parent_id.nil?
  end

end
