class Metadata::AdLayout < Metadata
  metadata_keys :ad_layout_sub_type_name, :ad_layout_name, :ad_layout_layout, :ad_layout_hint

  scope :key_sub_type_name, lambda { |*args| { :conditions => ["key_sub_type = ? AND key_name = ?", args.first, args.second] } }
  validates :ad_layout_name, :ad_layout_layout, :presence => true

  def self.get name, sub_type = nil
    self.find_ad_layout(name, sub_type)
  end

  def self.find_ad_layout name, key_sub_type = nil
    return self.find(:first, :conditions => ["key_sub_type = ? and key_name = ?", key_sub_type, name]) if key_sub_type
    return self.find(:first, :conditions => ["key_name = ?", name])
  end

  def key() self.ad_layout_name end

  def layout
    self.ad_layout_layout
  end

  private

  def set_meta_keys
    self.meta_type    = 'ad_layout'
    self.key_type     = 'app'
    self.key_sub_type ||= self.ad_layout_sub_type_name
    self.key_name     ||= self.ad_layout_name
  end

end
