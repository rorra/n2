class Card < ActiveRecord::Base

  if File.exist?(File.join(Rails.root, "config", "s3.yml"))
    PAPERCLIP_STORAGE_OPTIONS = {
      :storage        => :s3,
      :s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
      :path           => "/:attachment/:id/:style.jpg"
    }
  else
    PAPERCLIP_STORAGE_OPTIONS = {
      :path => ":rails_root/public/system/:attachment/:id/:style.jpg",
      :url  => "/system/:attachment/:id/:style.jpg"
    }
  end


  acts_as_moderatable

  has_many :sent_cards

  validates_presence_of :name, :short_caption, :long_caption

  validate :valid_slug_or_image

  has_attached_file :image, {
    :path => ":rails_root/public/images/cards/:id/:style.:extension",
    :url => "cards/:id/:style.:extension",
    :styles => {
      :thumb => {
        :geometry => '125x125#',
        :format => 'jpg'
      },
      :full => {
        :geometry => '550x550#',
        :format => 'jpg'
      }
    }
  }

  def image_path
    if self.image.file?
      self.image.url(:thumb)
    else
      img = self.slug_name =~ /png|jpg|gif|jpeg$/ ? self.slug_name : self.slug_name + ".png"
      "cards/#{img}"
    end
  end

  def already_sent_to sender
    list = sent_cards.sent_by sender.id
    list.map {|k| k.to_fb_user_id}.uniq.join ','
  end

  def expire
    self.class.sweeper.expire_card_all self
  end

  def self.expire_all
    self.sweeper.expire_card_all self.new
  end

  def self.sweeper
    CardSweeper
  end

  def valid_slug_or_image
    errors.add(:image, "You must upload an image") unless slug_name.present? or image.file?
  end

end
