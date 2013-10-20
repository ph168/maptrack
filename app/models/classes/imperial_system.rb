class ImperialSystem < SystemOfMeasurement
  def distance d
    (d / 1609.344).round 1
  end

  def distance_unit
    "mi"
  end

  def duration t
    (MetricSystem.new).duration t
  end

  def duration_unit
    (MetricSystem.new).duration_unit
  end

  def speed s
    (s * 3.6).round
  end

  def speed_unit
    "mph"
  end
end
