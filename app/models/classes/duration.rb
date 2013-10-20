class Duration < Quantity
  def format_with system
    system.duration(@value).to_s + " " + system.duration_unit
  end
end
