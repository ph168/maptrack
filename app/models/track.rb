class Track < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user
  has_many :coordinates, :order => "time"

  scope :for_user, lambda {|user| where("user_id = ?", user.id)}

  validates :name, :presence => true

  def to_json(options={})
    super(:include => :coordinates)
  end
end
