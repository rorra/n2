class Authentication < ActiveRecord::Base
  belongs_to :user
  #validates_presence_of :user, :provider, :uid

  named_scope :for_twitter, :conditions => { :provider => "twitter" }
  named_scope :for_facebook, :conditions => { :provider => "facebook" }
  named_scope :for_provider, lambda {|*args| { :conditions => { :provider => args.first } } }
end
