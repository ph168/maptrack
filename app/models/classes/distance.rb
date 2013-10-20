class Distance < Quantity
  def format_with system
    system.distance(@value).to_s + " " + system.distance_unit
  end
end
