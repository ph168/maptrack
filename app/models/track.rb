class Track < ActiveRecord::Base
  attr_accessible :name, :user_id
  
  belongs_to :user
  has_many :coordinates
  
  def to_json(options={})
    super(:include => :coordinates)
  end
end
