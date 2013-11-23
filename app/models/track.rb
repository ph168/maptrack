require 'track_info'

class Track < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user
  has_many :coordinates, :order => "time"

  before_create do
    info = TrackInfo.new(self) unless info
  end

  before_save do
    info.update! if info.needs_update?
  end

  scope :for_user, lambda {|user| where("user_id = ?", user.id)}

  validates :name, :presence => true
  validates :info, :presence => true

  def to_json(options={})
    super(:include => :coordinates)
  end

  def old?
    return false if coordinates.empty?
    coordinates.last.is_a_long_time_after? Time.now
  end

  def close!
    destination = coordinates.last
    destination.user_id = user_id
    destination.set_place!
  end
end
