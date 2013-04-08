class Coordinate < ActiveRecord::Base
  attr_accessible :track_id, :latitude, :longitude
  
  belongs_to :track
end
