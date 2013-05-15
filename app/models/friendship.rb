class Friendship < ActiveRecord::Base
  attr_accessible :consumer_id, :confirmed 
  belongs_to :initiator, :class_name => "User"
  belongs_to :consumer, :class_name => "User"

  validate :no_self_friendship

  def no_self_friendship
    if consumer_id == initiator_id
      errors.add("You cannot be a friend of yourself.")
    end
  end

  def users
    [initiator, consumer]
  end
end
