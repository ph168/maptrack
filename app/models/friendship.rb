class Friendship < ActiveRecord::Base
  attr_accessible :confirmed 
  belongs_to :initiator, :class_name => "User"
  belongs_to :consumer, :class_name => "User"
  
  def users
    [initiator, consumer]
  end
end
