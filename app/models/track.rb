class Track < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user
  has_many :coordinates, :order => "time"

  has_one_document :summary

  scope :for_user, lambda {|user| where("user_id = ?", user.id)}

  validates :name, :presence => true
  validates :summary, :presence => true

  def to_json(options={})
    super(:include => [:coordinates, :summary])
  end

  def old?
    return false if coordinates.empty?
    coordinates.last.is_a_long_time_after? Time.now
  end

  def close!
    destination = coordinates.last
    destination.user_id = user_id
    destination.delay.set_place!
  end
end
