class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  has_many :tracks

  has_many :friendships_as_initiator, :class_name => "Friendship", :foreign_key => "initiator_id"
  has_many :friendships_as_consumer, :class_name => "Friendship", :foreign_key => "consumer_id"
  def friendships
    friendships_as_initiator + friendships_as_consumer
  end
  def friends
    users = Array.new
    friendships.each{ |f| f.confirmed? and users += f.users.select { |u| u.id != self.id } }
    users
  end
end
