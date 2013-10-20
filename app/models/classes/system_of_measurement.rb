class SystemOfMeasurement
  include ActiveSupport::DescendantsTracker

  def distance d
    d
  end

  def distance_unit
    "m"
  end

  def duration t
    t
  end

  def duration_unit
    "s"
  end

  def speed s
    s
  end

  def speed_unit
    "m/s"
  end
end
