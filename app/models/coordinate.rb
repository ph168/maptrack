class Coordinate < ActiveRecord::Base
  attr_accessible :track_id, :latitude, :longitude, :time, :elevation
  
  belongs_to :track
end
