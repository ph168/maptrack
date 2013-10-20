class MetricSystem < SystemOfMeasurement
  def distance d
    (d / 1000.0).round 1
  end

  def distance_unit
    "km"
  end

  def duration t
    (t / 3600.0).round 1
  end

  def duration_unit
    "h"
  end

  def speed s
    (s * 3.6).round
  end

  def speed_unit
    "km/h"
  end
end
