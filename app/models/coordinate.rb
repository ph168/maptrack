class Coordinate < ActiveRecord::Base
  attr_accessor :user_id
  attr_accessible :track_id, :latitude, :longitude, :time, :elevation

  belongs_to :track

  has_one_document :place

  after_save do
    track.summary.update!
    self.delay.set_place
  end

  scope :for_user, lambda {|user| where("user_id = ?", user.id).joins(:track).readonly(false)}

  validate :user_may_access_track
  validates :latitude, :numericality => true
  validates :longitude, :numericality => true
  validates :elevation, :numericality => true, :allow_nil => true

  def set_place
    may_set_place
  end

  def set_place!
    may_set_place true
  end

  def is_a_long_time_after? t
    return false if track.summary.average_interval == 0.0
    (time.to_i - t.to_i).abs > (10 * track.summary.average_interval)
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

  def to_json(options={})
    super(:include => :place)
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

  def may_set_place forced=false
    return if self.place.data

    coords = track.coordinates
    if self.persisted? and coords.first != self
      prev = coords.where("id < ?", id).order("id").last
    else
      prev = coords.last
    end

    if forced or coords.first == self or prev.nil? or is_a_long_time_after? prev.time
      place = self.place
      place.data = query_place.instance_variable_get(:@attrs) unless self.place.data
      place.save
      return true
    end
  end
end
