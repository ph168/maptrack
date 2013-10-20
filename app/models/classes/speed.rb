class Speed < Quantity
  def format_with system
    system.speed(@value).to_s + " " + system.speed_unit
  end
end
