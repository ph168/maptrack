class Quantity

  attr_accessor :value

  def initialize val = 0.0
    @value = val
    @formatter = SystemOfMeasurement.new
  end

  def set_format system
    @formatter = system
  end

  def to_s
    format_with @formatter
  end

  def to_f
    @value.to_f
  end

  def to_i
    @value.to_i
  end
end
