require 'test_helper'

class CoordinateTest < ActiveSupport::TestCase
  setup do
    @track1 = tracks(:one)
    @track2 = tracks(:two)
    @coord1 = coordinates(:one)
    @coord2 = coordinates(:two)
    prepare_nominatim_stub
  end

  test "set_place_neg" do
    c = create_coordinate
    c.time = @coord2.time
    c.save
    assert c.place.nil?
  end

  test "set_place_pos" do
    c = create_coordinate
    c.time = @coord2.time + (@coord2.time - @coord1.time)*10
    c.save
    assert c.place
  end

  test "set_place_first" do
    assert @track2.coordinates.empty?
    c = create_coordinate
    c.track_id = @track2.id
    c.user_id = @track2.user_id
    c.save
    assert c.place
  end

  def create_coordinate
    c = Coordinate.new
    c.track_id = @track1.id
    c.user_id = @track1.user_id
    c.latitude = 1
    c.longitude = 2
    c.elevation = 3
    c.time = Time.new
    c
  end
end
