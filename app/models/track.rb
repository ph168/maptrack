class Track < ActiveRecord::Base
  attr_accessible :name, :public, :share_token

  belongs_to :user
  has_many :coordinates, :order => "time"

  has_one_document :summary

  scope :for_user, lambda {|user| where("user_id = ?", user.id)}
  scope :visible_for_user, lambda {|user|
    where("user_id = ? or (user_id in (?) and public=?)", user.id, user.friends, true)
  }

  validates :name, :presence => true
  validates :summary, :presence => true
  validates :share_token, :uniqueness => true

  before_save do
    self.public = false if self.public.nil?
    self.share_token = Devise.friendly_token if self.share_token.nil?
  end

  after_create do
    Story.new(track: self, user: self.user, action: "started a new track").save
  end

  def to_json(options={})
    super(:include => [:coordinates, :summary])
  end

  def old?
    return false if coordinates.empty?
    coordinates.last.is_a_long_time_after? Time.now
  end

  def close!
    destination = coordinates.last
    destination.user_id = user_id
    destination.delay.set_place!
  end
end
