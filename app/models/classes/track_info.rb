require 'duration'
require 'distance'
require 'speed'

class TrackInfo
  attr_reader :average_interval, :duration, :distance, :average_speed, :rise, :fall

  def initialize(track = Track.new)
    @track_id = track.id
    @average_interval = 0
    @duration = Duration.new
    @distance = Distance.new
    @average_speed = Speed.new
    @rise = Distance.new
    @fall = Distance.new
    @num = 0
    update! track
  end

  def needs_update?
    info_updated_at != track_updated_at
  end

  def update!(trk = track)
    if info_updated_at.nil?
      coords = trk.coordinates
    else
      coords = trk.coordinates.where ["time > ?", info_updated_at]
    end

    prev = coords.first
    coords.each do |c|
      @num += 1
      if c == prev
        next
      end

      @average_interval = (@average_interval * (@num-1) + c.time.to_i - prev.time.to_i) / @num
      @duration.value += (c.time.to_i - prev.time.to_i) # [s]
      @distance.value += prev.distance_to c # [m]
      @average_speed.value = @distance.value / @duration.value # [m/s]

      delev = c.elevation.to_f - prev.elevation.to_f
      @rise.value += delev if delev > 0
      @fall.value += (-delev) if delev < 0

      prev = c
    end

    updated! trk
  end

  def set_format system
    self.instance_variables.each do |var|
      var = self.instance_variable_get var
      var.set_format(system) if var.is_a? Quantity
    end
  end

  private

  def info_updated_at
    @last_coord_time
  end

  def track_updated_at(trk = track)
    last_coord = trk.coordinates.last
    last_coord.time unless last_coord.nil?
  end

  def updated!(trk)
    @last_coord_time = track_updated_at trk
  end

  def track
    @track_id ? Track.find(@track_id) : Track.new
  end
end