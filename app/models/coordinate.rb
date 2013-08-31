class Coordinate < ActiveRecord::Base
  attr_accessor :user_id
  attr_accessible :track_id, :latitude, :longitude, :time, :elevation

  belongs_to :track

  serialize :place, JSON

  before_save :set_place

  after_save do
    track.save if track.info.needs_update?
  end

  scope :for_user, lambda {|user| where("user_id = ?", user.id).joins(:track).readonly(false)}

  validate :user_may_access_track
  validates :latitude, :numericality => true
  validates :longitude, :numericality => true
  validates :elevation, :numericality => true, :allow_nil => true

  def set_place
    return if self.place
    coords = track.coordinates
    if self.persisted? and coords.first != self
      prev = coords.at(coords.index(self) - 1)
    else
      prev = coords.last
    end
    if prev.nil? or is_a_long_time_after? prev.time
      self.place = query_place unless self.place
    end
  end

  def is_a_long_time_after? t
    (time.to_i - t.to_i).abs > (10 * track.info.average_interval)
  end

  def distance_to coord
    # http://stackoverflow.com/questions/365826/calculate-distance-between-2-gps-coordinates
    dlat = (coord.latitude - latitude) * Math::PI / 180
    dlon = (coord.longitude - longitude) * Math::PI / 180
    lat1 = latitude * Math::PI / 180
    lat2 = coord.latitude * Math::PI / 180

    a = Math.sin(dlat/2) * Math.sin(dlat/2) +
            Math.sin(dlon/2) * Math.sin(dlon/2) * Math.cos(lat1) * Math.cos(lat2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    6371000 * c
  end

  private

  def user_may_access_track
    if track_id == nil or user_id != track.user_id
      errors.add(:track, "is not yours")
    end
  end

  def query_place
    query = Nominatim::Reverse.new
    query.lat latitude
    query.lon longitude
    query.fetch
  end
end
