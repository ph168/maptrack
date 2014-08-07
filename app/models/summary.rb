require 'duration'
require 'distance'
require 'speed'

class Summary
  include Mongoid::Document
  include Mongoid::ActiveRecordBridge

  belongs_to_record :track

  field :num, type: Integer, default: 0
  field :last_coord_time, type: Time
  field :average_interval, type: Float, default: 0.0
  field :duration, type: Float, default: 0.0
  field :distance, type: Float, default: 0.0
  field :average_speed, type: Float, default: 0.0
  field :rise, type: Float, default: 0.0
  field :fall, type: Float, default: 0.0

  def needs_update?
    self_updated_at != track_updated_at
  end

  def update!(trk = Track.find(track_id))
    if self_updated_at.nil?
      coords = trk.coordinates
    else
      coords = trk.coordinates.where ["time > ?", self_updated_at]
    end

    return if coords.size <= 1

    prev = coords.first
    coords.each do |c|
      self.num += 1
      if c == prev
        next
      end

      self.average_interval = (self.average_interval * (self.num-1) + c.time.to_i - prev.time.to_i) / self.num
      self.duration += (c.time.to_i - prev.time.to_i) # [s]
      self.distance += prev.distance_to c # [m]
      self.average_speed = self.distance / self.duration # [m/s]

      delev = c.elevation.to_f - prev.elevation.to_f
      self.rise += delev if delev > 0
      self.fall += (-delev) if delev < 0

      prev = c
    end

    updated! trk
    update
  end

  def set_format system
    self.instance_variables.each do |var|
      var = self.instance_variable_get var
      var.set_format(system) if var.is_a? Quantity
    end
  end

  private

  def self_updated_at
    self.last_coord_time
  end

  def track_updated_at(trk = track)
    last_coord = trk.coordinates.last
    last_coord.time unless last_coord.nil?
  end

  def updated!(trk)
    self.last_coord_time = track_updated_at trk
  end

  def track
    @track_id ? Track.find(@track_id) : Track.new
  end
end
