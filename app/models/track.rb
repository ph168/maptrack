class Track < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user
  has_many :coordinates, :order => "time"

  serialize :info, TrackInfo

  before_create do
    info = TrackInfo.new(self) unless info
  end

  before_save do
    info.update! if info.needs_update?
  end

  scope :for_user, lambda {|user| where("user_id = ?", user.id)}

  validates :name, :presence => true
  validates :info, :presence => true

  def to_json(options={})
    super(:include => :coordinates)
  end
end
