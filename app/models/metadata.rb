class Metadata < ActiveRecord::Base
  set_table_name :metadatas
  serialize :data, Hash

  belongs_to :metadatable, :polymorphic => true

  scope :key, lambda { |*args| { :conditions => ["key_name = ?", args.first] } }
  scope :key_type_name, lambda { |*args| { :conditions => ["key_type = ? AND key_name = ?", args.first, args.second] } }
  scope :key_type_sub_name, lambda { |*args| { :conditions => ["key_type = ? AND key_sub_type = ? AND key_name = ?", args.first, args.second, args.third] } }
  scope :meta_type, lambda { |*args| { :conditions => ["meta_type = ?", args.first] } }

  before_save :set_meta_keys

  # Given a list of keys, define methods that delegate
  # to the data hash. Try both strings and symbols when
  # looking up the attribute.
  def self.metadata_keys *keys
    keys.each do |key|
      key = key.to_s
      define_method key do
        data[key.to_s] || data[key.to_sym]
      end
      define_method "#{key}=" do |value|
        data[key] = value
      end
    end
  end

  def self.find_by_key_type_name key_type, key_name
    self.key_type_name(key_type, key_name).first
  end

  def self.find_by_key_type_sub_name key_type, key_sub_type, key_name
    self.find(:first, :conditions => ["key_type = ? and key_sub_type = ? and key_name = ?", key_type, key_sub_type, key_name])
  end

  def self.get_ad_slot key_sub_type, key_name
    # Can use SQL 'or' query here instead of doing two queries
    @ad_slot = self.key_type_sub_name('ads', key_sub_type, key_name).first
    @ad_slot = self.key_type_sub_name('ads', key_sub_type, 'default').first if @ad_slot.nil?
    @ad_slot
  end

  def self.get_default_ad_slot
    self.key_type_sub_name('ads', 'banner', 'default').first
  end

  # overwrite in sub metadata models as needed
  def set_meta_keys
  end
end
