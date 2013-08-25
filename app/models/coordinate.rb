class Coordinate < ActiveRecord::Base
  attr_accessor :user_id
  attr_accessible :track_id, :latitude, :longitude, :time, :elevation

  belongs_to :track

  serialize :place, JSON

  before_create :set_place

  after_save do
    track.save if track.info.needs_update?
  end

  scope :for_user, lambda {|user| where("user_id = ?", user.id).joins(:track).readonly(false)}

  validate :user_may_access_track
  validates :latitude, :numericality => true
  validates :longitude, :numericality => true
  validates :elevation, :numericality => true, :allow_nil => true

  private

  def user_may_access_track
    if track_id == nil or user_id != track.user_id
      errors.add(:track, "is not yours")
    end
  end

  def set_place
    prev = track.coordinates.last
    if prev.nil? or (time.to_i - prev.time.to_i) > (10 * track.info.average_interval)
      query = Nominatim::Reverse.new
      query.lat latitude
      query.lon longitude
      self.place = query.fetch unless self.place
    end
  end
end
