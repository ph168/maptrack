class TrackInfo
  attr_reader :average_interval

  def initialize(track = nil)
    @track_id = track.id
    @average_interval = 0
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
      coords = trk.coordinates.where ["created_at > ?", info_updated_at]
    end

    prev = coords.first
    coords.each do |c|
      @num += 1
      if c == prev
        next
      end
      @average_interval = (@average_interval * (@num-1) + c.time.to_i - prev.time.to_i) / @num
      prev = c
    end

    updated! trk
  end

  private

  def info_updated_at
    @last_coord_time
  end

  def track_updated_at(trk = track)
    last_coord = trk.coordinates.last
    last_coord.created_at unless last_coord.nil?
  end

  def updated!(trk)
    @last_coord_time = track_updated_at trk
  end

  def track
    Track.find @track_id
  end
end
