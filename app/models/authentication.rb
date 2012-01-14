class Authentication < ActiveRecord::Base
  belongs_to :user
  #validates_presence_of :user, :provider, :uid

  scope :for_twitter, :conditions => { :provider => "twitter" }
  scope :for_facebook, :conditions => { :provider => "facebook" }
  scope :for_provider, lambda {|*args| { :conditions => { :provider => args.first } } }
end
